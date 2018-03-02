module Components.SlotCell (render) where

import Prelude

import Data.Array (any)
import Data.Date (Date)
import Data.Newtype (unwrap)
import Preferences (DomainEvent(..))
import State (State)
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (Slot(..), TimeSlot)

render :: TimeSlot -> _ -> State -> Date -> ReactElement
render timeslot dispatch state date =
  R.div [ RP.className "table-cell" ]
    [ R.label [ RP.className $ if isChecked then "slot-checkbox is-checked" else "slot-checkbox" ]
      [ R.input [ RP._type "checkbox"
                , RP.checked isChecked
                , inputStyle
                , RP.onChange \_ -> dispatch $ SingleToggle $ Slot date timeslot
                ] []
      ]
    ]
  where
    isChecked = any (eq $ Slot date timeslot) (unwrap state).slots

    inputStyle = RP.style { visibility: "hidden" }
