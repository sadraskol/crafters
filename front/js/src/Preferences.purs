module Preferences ( Event(..)
                   , applyPreferences
                   , slotsFromDates
                   , removeTimeSlot
                   , removeSlot
                   , removeDate
                   ) where

import Prelude

import Data.Array (concatMap, filter, foldr, insert)
import Data.Date (Date)
import Data.Foldable (any)
import Data.Newtype (unwrap)
import Slot (Slot(..), TimeSlot(..))
import State (State, changeSlots, initialState)

data Event
  = SingleToggle Slot
  | DateToggle Date
  | TimeSlotToggle TimeSlot (Array Date)

applyPreferences :: Event -> State -> State
applyPreferences (SingleToggle slot) state = if any (eq slot) (unwrap state).slots
  then removeSlot slot state
  else changeSlots (insert slot) state
applyPreferences (DateToggle date) state = if any (\(Slot d _) -> d == date) (unwrap state).slots
  then removeDate date state
  else changeSlots (\slots -> foldr insert slots ((Slot date) <$> [Lunch, Evening])) state
applyPreferences (TimeSlotToggle timeslot range) state = if any (\(Slot _ t) -> t == timeslot) (unwrap state).slots
  then removeTimeSlot timeslot state
  else changeSlots (\slots -> foldr insert slots ((\d -> Slot d timeslot) <$> range)) state

slotsFromDates :: Array Date -> State
slotsFromDates arr = changeSlots (const $ range arr) initialState
    where
      range :: Array Date -> Array Slot
      range = concatMap (\date -> [ Slot date Lunch, Slot date Evening ])

removeTimeSlot :: TimeSlot -> State -> State
removeTimeSlot timeslot = changeSlots $ filter (\(Slot _d t) -> t /= timeslot)

removeSlot :: Slot -> State -> State
removeSlot slot = changeSlots $ filter (\s-> s /= slot)

removeDate :: Date -> State -> State
removeDate date = changeSlots $ filter (\(Slot d _t) -> d /= date)
