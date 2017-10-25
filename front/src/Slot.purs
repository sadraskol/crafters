module Slot
  ( TimeSlot(..)
  , Slot(..)
  , slotsFromDates
  ) where

import Prelude
import Data.Array (concatMap)
import Data.Date (Date)
import Data.Generic (class Generic)

data Slot = Slot TimeSlot Date

derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot
derive instance genericSlot :: Generic Slot

instance showSlot :: Show Slot where
  show (Slot t d) = show t <> " " <> show d

data TimeSlot = Lunch | Evening

derive instance eqTimeSlot :: Eq TimeSlot
derive instance ordTimeSlot :: Ord TimeSlot
derive instance genericTimeSlot :: Generic TimeSlot

instance showTimeSlot :: Show TimeSlot where
  show Lunch = "Lunch"
  show Evening = "Evening"

slotsFromDates :: Array Date -> Array Slot
slotsFromDates = concatMap \date -> [ Slot Lunch date, Slot Evening date ]
