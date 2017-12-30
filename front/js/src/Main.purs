module Main where

import Network.HTTP.Affjax
import Prelude

import Calendar (getWeekdaysInRange, getDate)
import Components.Container (Action(..))
import Components.DateTitle as DateTitle
import Components.SlotCell as SlotCell
import Components.TimeSlotTitle as TimeSlotTitle
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log)
import Control.Monad.Trans.Class (lift)
import DOM.HTML (window)
import DOM.HTML.Types (htmlDocumentToNonElementParentNode)
import DOM.HTML.Window (document)
import DOM.Node.Node (textContent)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (ElementId(..), documentToNonElementParentNode, elementToNode)
import Data.Argonaut.Core (fromString)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Date (Date)
import Data.Date as Date
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), fromJust, fromMaybe)
import Data.Newtype (unwrap)
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
  _ <- lift $ post_ ("/api/preferences/" <> (unwrap props).id) (encodeJson state)
  void $ T.cotransform id

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
