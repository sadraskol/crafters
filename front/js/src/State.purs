module State (State(..), initialState, changeSlots, changeName, addActivity, removeActivity) where

import Prelude

import Activity (Activity)
import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField, getFieldOptional)
import Data.Argonaut.Encode (class EncodeJson, encodeJson, (:=), (~>))
import Data.Array (filter, (:))
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap)
import Slot (Slot)

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
        , activities: filter ((/=) activity) (unwrap state).activities
        }
