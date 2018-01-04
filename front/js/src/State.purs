module State (State(..), initialState, changeSlots, changeName, Activity(..)) where

import Prelude

import Data.Argonaut.Core (Json, fromString, jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField, getFieldOptional)
import Data.Argonaut.Encode (class EncodeJson, encodeJson, (:=), (~>))
import Data.Array (filter, (:))
import Data.Either (Either(Left))
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap)
import Slot (Slot)

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

newtype State =
  State { slots :: Array Slot
        , name :: Maybe String
        , activities :: Array Activity
        }

derive instance newtypeState :: Newtype State _
derive instance eqState :: Eq State
instance showState :: Show State where
  show :: State -> String
  show (State { slots: slots, name: name, activities: activities})
    = "State { slots: " <> show slots <>
      ", name: " <> show name <>
      ", activities" <> show activities <> " }"

instance decodeState :: DecodeJson State where
  decodeJson :: Json -> Either String State
  decodeJson json = do
    obj <- decodeJson json
    slots <- getField obj "slots"
    activities <- getField obj "activities"
    name <- getFieldOptional obj "name"
    pure $ State { slots: slots
                 , name: name
                 , activities: activities
                 }

instance encodeState :: EncodeJson State where
  encodeJson :: State -> Json
  encodeJson state
    = encodeJson
      ( "slots" := (unwrap state).slots
      ~> "name" := (unwrap state).name
      ~> "activities" := (unwrap state).activities
      ~> jsonEmptyObject
      )

initialState :: State
initialState = State { slots : [], name : Nothing, activities: [] }

changeSlots :: (Array Slot -> Array Slot) -> State -> State
changeSlots changer state =
  State { slots: changer (unwrap state).slots
        , name: (unwrap state).name
        , activities: (unwrap state).activities
        }

changeName :: String -> State -> State
changeName name state
  = State { slots: (unwrap state).slots
          , name: Just name
          , activities: (unwrap state).activities
          }

addActivity :: Activity -> State -> State
addActivity activity state =
  State { slots: (unwrap state).slots
        , name: (unwrap state).name
        , activities: activity : (unwrap state).activities
        }

removeActivity :: Activity -> State -> State
removeActivity activity state =
  State { slots: (unwrap state).slots
        , name: (unwrap state).name
        , activities: filter ((==) activity) (unwrap state).activities
        }
