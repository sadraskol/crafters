module Calendar where

import Prelude

import Data.Date as Date
import Data.DateTime as DateTime
import Data.Enum (toEnum)
import Data.Maybe (Maybe(..), fromJust)
import Data.Time.Duration as Duration

import Partial.Unsafe (unsafePartial)

nextMonday :: Date.Date -> Maybe Date.Date
nextMonday date = case DateTime.weekday date of
  DateTime.Monday -> Just date
  _ -> nextMonday =<< nextDay date

nextDay :: Date.Date -> Maybe Date.Date
nextDay date = DateTime.date <$> DateTime.adjust (Duration.Days 1.0) dateTime
  where
    anyTime = unsafePartial $ fromJust $ DateTime.Time <$> toEnum 17 <*> toEnum 42 <*> toEnum 16 <*> toEnum 362
    dateTime = DateTime.DateTime date anyTime

fullMonth :: Date.Date -> Array Date.Date
fullMonth date = []
