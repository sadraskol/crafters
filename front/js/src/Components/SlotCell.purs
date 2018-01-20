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
  R.li [ RP.className "table-cell" ]
    [ R.label [ labelStyle ]
      [ R.input [ RP._type "checkbox"
                , inputStyle
                , RP.checked isChecked
                , RP.onClick \_ -> dispatch $ SingleToggle $ Slot date timeslot
                ] []
      ]
    ]
  where
    isChecked = any (eq $ Slot date timeslot) (unwrap state).slots

    labelStyle = RP.style { "background-color": if isChecked then "hsl(171, 100%, 41%)" else "#080408"
                          , cursor: "pointer" }

    inputStyle = RP.style { "visibility" : "hidden" }
