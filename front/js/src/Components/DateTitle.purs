module Components.DateTitle where

import Prelude

import Calendar (frenchWeekday, frenchMonth)
import Data.Date (Date)
import Data.Date as Date
import Data.Enum (fromEnum)
import Preferences (DomainEvent(..))
import State (State)
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP

render :: _ -> State -> Date -> ReactElement
render dispatch _ date =
  R.div [ RP.onClick \_ -> dispatch $ DateToggle date
       , RP.style { cursor: "pointer" }
       , RP.className "table-header has-text-centered"
       ] $ dateToElement date

dateToElement :: Date -> Array ReactElement
dateToElement date
  = [ R.div' [ R.text (frenchWeekday date) ]
    , R.div [RP.className "has-text-weight-bold"] [ R.text (show $ fromEnum $ Date.day date) ]
    , R.div' [ R.text (frenchMonth date) ] ]
