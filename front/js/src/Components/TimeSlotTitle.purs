module Components.TimeSlotTitle where

import Prelude

import Components.Container (Action(..))
import Data.Date (Date)
import Preferences (Event(..))
import State (State)
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (TimeSlot(..))

render :: TimeSlot -> Array Date -> _ -> State -> ReactElement
render timeslot range dispatch _ = R.td [ RP.onClick \_ -> dispatch $ Preference $ TimeSlotToggle timeslot range
                       , cellStyle
                       ] [R.text $ frenchTimeslot timeslot]
  where
    frenchTimeslot Lunch = "Midi"
    frenchTimeslot Evening = "Soirée"

    cellStyle = RP.style { cursor: "pointer" }
