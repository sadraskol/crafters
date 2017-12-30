module StaticProps where

import Prelude

import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField)
import Data.Date (Date, canonicalDate)
import Data.Either (Either, fromRight)
import Data.Enum (toEnum)
import Data.Maybe (fromJust)
import Data.Newtype (class Newtype)
import Partial.Unsafe (unsafePartial)

newtype StaticProps =
  StaticProps { id :: String
        , range :: Array Date
        }

derive instance newtypeStaticProps :: Newtype StaticProps _
derive instance eqStaticProps :: Eq StaticProps
instance showStaticProps :: Show StaticProps where
  show :: StaticProps -> String
  show (StaticProps { id: id, range: range}) = "StaticProps { id: " <> show id <> ", range: " <> show range <> " }"


getUnsafeDate :: Int -> Int -> Int -> Date
getUnsafeDate year month day = unsafePartial fromJust $ canonicalDate <$> toEnum year <*> toEnum month <*> toEnum day

decodeDate :: Json -> Date
decodeDate json = unsafePartial fromRight do
  obj <- decodeJson json
  day <- getField obj "day"
  month <- getField obj "month"
  year <- getField obj "year"
  pure $ getUnsafeDate year month day

instance decodeStaticProps :: DecodeJson StaticProps where
  decodeJson :: Json -> Either String StaticProps
  decodeJson json = do
    obj <- decodeJson json
    id <- getField obj "id"
    range <- getField obj "range"
    pure $ StaticProps { range: decodeDate <$> range
                 , id: id
                 }
