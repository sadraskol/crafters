module Activity (Activity(..)) where

import Data.Argonaut.Core (Json, fromString)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Encode (class EncodeJson)
import Data.Either (Either(..))
import Prelude (class Eq, class Show, bind, pure, (<>))

data Activity
  = DDD
  | LunchDojo
  | EveningDojo

derive instance eqActivity :: Eq Activity
instance showActivity :: Show Activity where
  show :: Activity -> String
  show DDD = "DDD"
  show LunchDojo = "Dojo du midi"
  show EveningDojo = "Dojo du soir"

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
