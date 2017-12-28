module Components.SlotCell (render) where

import Prelude

import Components.Container (Action(..))
import Data.Array (any)
import Data.Date (Date)
import Data.Newtype (unwrap)
import Preferences (Event(..))
import State (State)
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (Slot(..), TimeSlot)

render :: TimeSlot -> _ -> State -> Date -> ReactElement
render timeslot dispatch state date =
  R.td [ tdStyle ]
    [ R.label [ RP.className "table-timeslot ", labelStyle ]
      [ R.input [ RP._type "checkbox"
                , inputStyle
                , RP.checked isChecked
                , RP.onClick \_ -> dispatch $ Preference $ SingleToggle $ Slot date timeslot
                ] []
      ]
    ]
  where
    isChecked = any (eq $ Slot date timeslot) (unwrap state).slots
    tdStyle = RP.style { "text-align": "center"
                       , padding: "1px"
                       , "min-width": "40px"
                       , "min-height": "40px"
                       }

    labelStyle = RP.style { "background-color": if isChecked then "green" else "red"
                          , cursor: "pointer" }

    inputStyle = RP.style { "visibility" : "hidden" }
