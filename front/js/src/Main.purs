module Main where

import Network.HTTP.Affjax
import Prelude (Unit, bind, discard, id, pure, void, ($), (<$>), (<<<), (<>), (=<<))

import Components.Container (Action(..))
import Components.DateTitle as DateTitle
import Components.SlotCell as SlotCell
import Components.TimeSlotTitle as TimeSlotTitle
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (log)
import Control.Monad.Trans.Class (lift)
import DOM.HTML (window)
import DOM.HTML.Location (assign)
import DOM.HTML.Types (htmlDocumentToNonElementParentNode)
import DOM.HTML.Window (document, location)
import DOM.Node.Node (textContent)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (ElementId(..), elementToNode)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Date (Date)
import Data.Either (Either(..))
import Data.Maybe (Maybe(Just, Nothing), fromMaybe)
import Data.Newtype (unwrap)
import Network.HTTP.StatusCode (StatusCode(..))
import Preferences (applyPreferences)
import React (Event, ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (TimeSlot(..))
import State (State, changeName, initialState)
import StaticProps (StaticProps(..))
import Thermite (EventHandler)
import Thermite as T
import ThermiteUtils (defaultMain)
import Unsafe.Coerce (unsafeCoerce)

getInit :: Eff _ String
getInit = do
  win <- window
  doc <- document win
  maybeEl <- getElementById (ElementId "init-props") (htmlDocumentToNonElementParentNode doc)
  case maybeEl of
    Nothing -> pure ""
    Just el -> textContent <<< elementToNode $ el

render :: T.Render State StaticProps Action
render dispatch props state _ =
  [ R.table [] [
      R.tbody [] [
        R.tr [] ([R.td' []] <> (dateCell <$> range)),
        R.tr [] (renderLine Lunch range),
        R.tr [] (renderLine Evening range)
      ]
    ],
    R.label [] [
      R.span' [R.text "Ton nom: "],
      R.input [ RP.value $ fromMaybe "" (unwrap state).name
              , RP.onChange $ dispatchName dispatch] []
    ],
    R.button [RP.onClick \_ -> dispatch $ Submit] [R.text "Valider"]
  ]

  where
    range :: Array Date
    range = (unwrap props).range
    renderLine :: TimeSlot -> Array Date -> Array ReactElement
    renderLine timeslot range
      = ([TimeSlotTitle.render timeslot range dispatch state]
      <> ((SlotCell.render timeslot dispatch state) <$> range))
    dateCell = DateTitle.render dispatch state

dispatchName :: (Action -> EventHandler) -> Event -> EventHandler
dispatchName dispatch e = dispatch $ Name $ (unsafeCoerce e).target.value

performAction :: T.PerformAction _ State StaticProps Action
performAction (Name name) _ state = void $ T.cotransform $ changeName name
performAction (Preference event) _ _ = void $ T.cotransform $ applyPreferences event
performAction Submit props state = do
  response <- lift $ post_ ("/api/preferences/" <> monthId) (encodeJson state)
  case response of
    {status: StatusCode 200} -> liftEff $ (assign $ "/month/" <> monthId) =<< (location =<< window)
    _ -> liftEff $ log "failure"
  void $ T.cotransform id

    where
      monthId :: String
      monthId = (unwrap props).id

spec :: forall e. T.Spec _ State StaticProps Action
spec = T.simpleSpec performAction render

main :: forall e. Eff _ Unit
main = do
  str <- getInit
  case decodeJson =<< jsonParser str of
    Right props -> defaultMain spec initialState props
    Left message -> do
      log ("error: " <> message)
      defaultMain spec initialState (StaticProps {id: "", range: []})
