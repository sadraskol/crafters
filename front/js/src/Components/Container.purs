module Components.Container (Action(..)) where

import Preferences (Event)

data Action
  = Submit
  | Preference Event
  | Name String
