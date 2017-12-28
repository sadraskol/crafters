module Components.DateTitle where

import Prelude

import Calendar (frenchWeekday)
import Components.Container (Action(..))
import Data.Date (Date)
import Data.Date as Date
import Data.Enum (fromEnum)
import Preferences (Event(..))
import State (State)
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP

render :: _ -> State -> Date -> ReactElement
render dispatch _ date =
  R.td [ RP.onClick \_ -> dispatch $ Preference $ DateToggle date
       , RP.style { cursor: "pointer"
                  , padding: "3px"
                  , "margin-right": "2px"
                  }
       ] [R.text $ dateToString date]

dateToString :: Date -> String
dateToString date = (frenchWeekday date) <> " " <> (show $ fromEnum $ Date.day date)
