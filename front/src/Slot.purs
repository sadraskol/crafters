module Slot
  ( TimeSlot(..)
  , Slot(..)
  , slotsFromDates
  , filterTimeSlot
  , removeSlot
  , removeDate
  ) where

import Prelude
import Data.Array (concatMap, filter)
import Data.Date (Date)
import Data.Generic (class Generic)

data Slot = Slot Date TimeSlot

derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot
derive instance genericSlot :: Generic Slot

instance showSlot :: Show Slot where
  show :: Slot -> String
  show (Slot d t) = show d <> " " <> show t

data TimeSlot = Lunch | Evening

derive instance eqTimeSlot :: Eq TimeSlot
derive instance ordTimeSlot :: Ord TimeSlot
derive instance genericTimeSlot :: Generic TimeSlot

instance showTimeSlot :: Show TimeSlot where
  show Lunch = "Lunch"
  show Evening = "Evening"

slotsFromDates :: Array Date -> Array Slot
slotsFromDates = concatMap \date -> [ Slot date Lunch, Slot date Evening ]

filterTimeSlot :: TimeSlot -> Array Slot -> Array Slot
filterTimeSlot timeslot = filter \(Slot _d t) -> t /= timeslot

removeSlot :: Slot -> Array Slot -> Array Slot
removeSlot slot = filter \s-> s /= slot

removeDate :: Date -> Array Slot -> Array Slot
removeDate date = filter \(Slot d _t) -> d /= date
