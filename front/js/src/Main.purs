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
import Data.Argonaut.Encode (encodeJson)
import Data.Date (Date)
import Data.Date as Date
import Data.Maybe (Maybe(..), fromJust, fromMaybe)
import Data.Newtype (unwrap)
import Preferences (applyPreferences)
import React (Event, ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (TimeSlot(..))
import State (State, changeName, initialState)
import Thermite (EventHandler)
import Thermite as T
import ThermiteUtils (defaultMain)
import Unsafe.Coerce (unsafeCoerce)

range :: Array Date
range = getWeekdaysInRange (getDate 2017 Date.February 27) (getDate 2017 Date.March 29)

getInit :: Eff _ String
getInit = do
  win <- window
  doc <- document win
  maybeEl <- getElementById (ElementId "init-props") (htmlDocumentToNonElementParentNode doc)
  case maybeEl of
    Nothing -> pure ""
    Just el -> textContent <<< elementToNode $ el

render :: forall a. T.Render State a Action
render dispatch _ state _ =
  [ R.table [] [
      R.tbody [] [
        R.tr [] ([R.td' []] <> (dateCell <$> range)),
        R.tr [] (renderLine Lunch range),
        R.tr [] (renderLine Evening range)
      ]
    ],
    R.ul' $ (\slot -> R.li' [R.text $ show slot]) <$> (unwrap state).slots,
    R.input [ RP.value $ fromMaybe "" (unwrap state).name
            , RP.onChange $ dispatchName dispatch] [],
    R.button [RP.onClick \_ -> dispatch $ Submit] [R.text "Valider"]
  ]

  where
    renderLine :: TimeSlot -> Array Date -> Array ReactElement
    renderLine timeslot range
      = ([TimeSlotTitle.render timeslot range dispatch state]
      <> ((SlotCell.render timeslot dispatch state) <$> range))
    dateCell = DateTitle.render dispatch state

dispatchName :: (Action -> EventHandler) -> Event -> EventHandler
dispatchName dispatch e = dispatch $ Name $ (unsafeCoerce e).target.value

performAction :: forall a e. T.PerformAction _ State a Action
performAction (Name name) _ state = void $ T.cotransform $ changeName name
performAction (Preference event) _ _ = void $ T.cotransform $ applyPreferences event
performAction Submit _ state = do
  _ <- lift $ post_ "/api/preferences/id" (encodeJson state)
  void $ T.cotransform id

spec :: forall a e. T.Spec _ State a Action
spec = T.simpleSpec performAction render

main :: forall e. Eff _ Unit
main = do
  str <- getInit
  log str
  defaultMain spec initialState unit
