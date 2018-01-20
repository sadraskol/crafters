module Components.TimeSlotTitle where

import Prelude

import Data.Date (Date)
import Preferences (DomainEvent(..))
import State (State)
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (TimeSlot(..))

render :: TimeSlot -> Array Date -> _ -> State -> ReactElement
render timeslot range dispatch _ = R.li [ RP.onClick \_ -> dispatch $ TimeSlotToggle timeslot range
                       , RP.className "timeslot-cell"
                       ] [R.text $ frenchTimeslot timeslot]
  where
    frenchTimeslot Lunch = "Midi"
    frenchTimeslot Evening = "Soirée"

    cellStyle = RP.style { cursor: "pointer"
                         , height: 40}
