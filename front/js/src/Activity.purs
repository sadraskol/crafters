module Activity (Activity(..), toggleActivity) where

import Data.Argonaut.Core (Json, fromString)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Array (filter, insert)
import Data.Either (Either(..))
import Data.Enum (class Enum)
import Data.Foldable (any)
import Data.Maybe (Maybe(..))
import Prelude (class Bounded, class Eq, class Ord, class Show, bind, pure, (/=), (<>), (==))

data Activity
  = DDD
  | LunchDojo
  | EveningDojo

derive instance eqActivity :: Eq Activity
derive instance ordActivity :: Ord Activity

instance showActivity :: Show Activity where
  show :: Activity -> String
  show DDD = "DDD"
  show LunchDojo = "Dojo du midi"
  show EveningDojo = "Dojo du soir"

instance boundedActivity :: Bounded Activity where
  bottom = DDD
  top = EveningDojo

instance enumActivity :: Enum Activity where
  succ :: Activity -> Maybe Activity
  succ DDD = Just LunchDojo
  succ LunchDojo = Just EveningDojo
  succ EveningDojo = Nothing
  pred :: Activity -> Maybe Activity
  pred DDD = Nothing
  pred LunchDojo = Just DDD
  pred EveningDojo = Just LunchDojo

instance decodeActivity :: DecodeJson Activity where
  decodeJson :: Json -> Either String Activity
  decodeJson json = do
    obj <- decodeJson json
    case obj of
      "ddd" -> pure DDD
      "lunch_dojo" -> pure LunchDojo
      "evening_dojo" -> pure EveningDojo
      any -> Left ("Activity DecodeJson: " <> any <> " is not (ddd|lunch_dojo|evening_dojo)")

instance encodeActivity :: EncodeJson Activity where
  encodeJson :: Activity -> Json
  encodeJson DDD = fromString "ddd"
  encodeJson LunchDojo = fromString "lunch_dojo"
  encodeJson EveningDojo = fromString "evening_dojo"

toggleActivity :: Activity -> Array Activity -> Array Activity
toggleActivity activity activities
  = if any (\a -> a == activity) activities
    then filter (\a -> a /= activity) activities
    else insert activity activities
