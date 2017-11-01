module Components.SlotCell (render) where

import Prelude

import Components.Container (Action(..))
import Data.Array (any)
import Data.Date (Date)
import Preferences (Event(..), State)
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (Slot(..), TimeSlot)

render :: TimeSlot -> _ -> State -> Date -> ReactElement
render timeslot dispatch state date =
  R.td [ tdStyle ]
    [ R.label [ labelStyle ]
      [ R.input [ RP._type "checkbox"
                , inputStyle
                , RP.checked isChecked
                , RP.onClick \_ -> dispatch $ Preference $ SingleToggle $ Slot date timeslot
                ] []
      ]
    ]
  where
    isChecked = any (eq $ Slot date timeslot) state
    tdStyle = RP.style { "text-align": "center"
                       , padding: "1px"
                       , "min-width": "40px"
                       , "min-height": "40px"
                       }

    labelStyle = RP.style { "background-color": if isChecked then "green" else "red"
                          , cursor: "pointer" }

    inputStyle = RP.style { "visibility" : "hidden" }
