module Slot (TimeSlot(..), Slot(..), toggleSingle, toggleDate, toggleTimeSlot) where

import Prelude

import Data.Argonaut.Core (Json, fromString, jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField)
import Data.Argonaut.Encode (class EncodeJson, encodeJson, (:=), (~>))
import Data.Array (insert, filter, foldr)
import Data.Date (Date, canonicalDate, day, month, year)
import Data.Either (Either(..))
import Data.Enum (fromEnum, toEnum)
import Data.Foldable (any)
import Data.Generic (class Generic)
import Data.Maybe (fromJust)
import Partial.Unsafe (unsafePartial)

data Slot = Slot Date TimeSlot

derive instance eqSlot :: Eq Slot
derive instance ordSlot :: Ord Slot
derive instance genericSlot :: Generic Slot

instance showSlot :: Show Slot where
  show :: Slot -> String
  show (Slot d t) = show d <> " " <> show t


getUnsafeDate :: Int -> Int -> Int -> Date
getUnsafeDate year month day = unsafePartial fromJust $ canonicalDate <$> toEnum year <*> toEnum month <*> toEnum day

instance decodeSlot :: DecodeJson Slot where
  decodeJson :: Json -> Either String Slot
  decodeJson json = do
    obj <- decodeJson json
    date <- getField obj "date"
    day <- getField date "day"
    month <- getField date "month"
    year <- getField date "year"
    timeslot <- getField obj "timeslot"
    pure $ Slot (getUnsafeDate year month day) timeslot

instance encodeSlot :: EncodeJson Slot where
  encodeJson :: Slot -> Json
  encodeJson (Slot date timeslot)
    = encodeJson
      ( "date" :=
        ( "day" := (fromEnum $ day date)
        ~> "month" := (fromEnum $ month date)
        ~> "year" := (fromEnum $ year date)
        ~> jsonEmptyObject
        )
      ~> "timeslot" := encodeJson timeslot
      ~> jsonEmptyObject
      )

data TimeSlot = Lunch | Evening

derive instance eqTimeSlot :: Eq TimeSlot
derive instance ordTimeSlot :: Ord TimeSlot
derive instance genericTimeSlot :: Generic TimeSlot

instance decodeTimeSlot :: DecodeJson TimeSlot where
  decodeJson :: Json -> Either String TimeSlot
  decodeJson json = do
    obj <- decodeJson json
    case obj of
      "lunch" -> pure $ Lunch
      "evening" -> pure $ Evening
      any -> Left ("TimeSlot DecodeJson: " <> any <> " is not (lunch|evening)")

instance encodeTimeSlot :: EncodeJson TimeSlot where
  encodeJson :: TimeSlot -> Json
  encodeJson Lunch = fromString "lunch"
  encodeJson Evening = fromString "evening"

instance showTimeSlot :: Show TimeSlot where
  show Lunch = "Lunch"
  show Evening = "Evening"

toggleSingle :: Slot -> Array Slot -> Array Slot
toggleSingle slot slots
  = if any (eq slot) slots
    then filter (\s-> s /= slot) slots
    else insert slot slots

toggleDate :: Date -> Array Slot -> Array Slot
toggleDate date slots
  = if any (\(Slot d _) -> d == date) slots
    then filter (\(Slot d _) -> d /= date) slots
    else foldr insert slots ((Slot date) <$> [Lunch, Evening])

toggleTimeSlot :: TimeSlot -> Array Date -> Array Slot -> Array Slot
toggleTimeSlot timeslot range slots
  = if any (\(Slot _ t) -> t == timeslot) slots
    then filter (\(Slot _d t) -> t /= timeslot) slots
    else foldr insert slots ((\d -> Slot d timeslot) <$> range)
