module Preferences ( State
                   , Event(..)
                   , applyPreferences
                   , initialState
                   ) where

import Prelude

import Data.Array (foldr, insert)
import Data.Date (Date)
import Data.Foldable (any)
import Slot (Slot(..), TimeSlot(..), removeDate, removeSlot, removeTimeSlot)

data Event
  = SingleToggle Slot
  | DateToggle Date
  | TimeSlotToggle TimeSlot (Array Date)

type State = Array Slot

applyPreferences :: Event -> State -> State
applyPreferences (SingleToggle slot) state = if any (eq slot) state
  then removeSlot slot state
  else insert slot state
applyPreferences (DateToggle date) state = if any (\(Slot d _) -> d == date) state
  then removeDate date state
  else foldr insert state ((Slot date) <$> [Lunch, Evening])
applyPreferences (TimeSlotToggle timeslot range) state = if any (\(Slot _ t) -> t == timeslot) state
  then removeTimeSlot timeslot state
  else foldr insert state ((\d -> Slot d timeslot) <$> range)

initialState :: State
initialState = []
