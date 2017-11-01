module Main where

import Prelude

import Calendar (getWeekdaysInRange, getDate)
import Components.SlotCell as SlotCell
import Components.DateCell as DateCell
import Components.TimeSlotCell as TimeSlotCell
import Components.Container (Action(..))
import Control.Monad.Aff.Console (CONSOLE, log)
import Control.Monad.Eff (Eff)
import Control.Monad.Trans.Class (lift)
import DOM (DOM)
import Data.Date (Date)
import Data.Date as Date
import Preferences (State, initialState, applyPreferences)
import React.DOM as R
import React.DOM.Props as RP
import Slot (TimeSlot(..))
import Thermite as T
import ThermiteUtils (defaultMain)

range :: Array Date
range = getWeekdaysInRange (getDate 2017 Date.February 27) (getDate 2017 Date.March 29)

render :: forall a. T.Render State a Action
render dispatch _ state _ =
  [ R.table [] [
      R.tbody [] [
        R.tr [] ([R.td' []] <> (dateCell <$> range)),
        R.tr [] ([TimeSlotCell.render Lunch range dispatch state] <> (lunchCell <$> range)),
        R.tr [] ([TimeSlotCell.render Evening range dispatch state] <> (eveningCell <$> range))
      ]
    ],
    R.ul' $ (\slot -> R.li' [R.text $ show slot]) <$> state,
    R.button [RP.onClick \_ -> dispatch $ Submit] [R.text "Valider"]
  ]

  where
    lunchCell = SlotCell.render Lunch dispatch state
    eveningCell = SlotCell.render Evening dispatch state
    dateCell = DateCell.render dispatch state

performAction :: forall a e. T.PerformAction (console :: CONSOLE | e) State a Action
performAction (Preference event) _ _ = void $ T.cotransform $ applyPreferences event
performAction Submit _ _ = do
  lift $ log "Submit"
  void $ T.cotransform id

spec :: forall a e. T.Spec (console :: CONSOLE | e) State a Action
spec = T.simpleSpec performAction render

main :: forall e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
main = defaultMain spec initialState unit
