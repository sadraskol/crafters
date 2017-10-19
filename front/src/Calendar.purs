module Calendar where

import Prelude

import Data.Array (filter)
import Data.Date as Date
import Data.DateTime as DateTime
import Data.Enum (toEnum)
import Data.Int (toNumber)
import Data.Maybe (fromJust)
import Data.Time.Duration as Duration

import Partial.Unsafe (unsafePartial)

addDay :: Int -> Date.Date -> Date.Date
addDay x date = unsafePartial $ fromJust $ DateTime.date <$> DateTime.adjust (Duration.Days $ toNumber x) dateTime
  where
    anyTime = unsafePartial $ fromJust $ DateTime.Time <$> toEnum 17 <*> toEnum 42 <*> toEnum 16 <*> toEnum 362
    dateTime = DateTime.DateTime date anyTime

isAWeekday :: Date.Date -> Boolean
isAWeekday date = case Date.weekday date of
  Date.Saturday -> false
  Date.Sunday -> false
  _ -> true

getWeekdaysInRange :: Date.Date -> Date.Date -> Array Date.Date
getWeekdaysInRange start end = filter isAWeekday (getDaysInRange start end)

getDaysInRange :: Date.Date -> Date.Date -> Array Date.Date
getDaysInRange bottom up  | bottom < up  = [bottom] <> getWeekdaysInRange (addDay 1 bottom) up
                          | bottom == up = [bottom]
                          | otherwise    = getWeekdaysInRange up bottom
