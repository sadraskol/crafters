module State (State(..), initialState, changeSlots, changeName) where

import Prelude

import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField, getFieldOptional)
import Data.Argonaut.Encode (class EncodeJson, encodeJson, (:=), (~>))
import Data.Either (Either)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap)
import Slot (Slot)

newtype State =
  State { slots :: Array Slot
        , name :: Maybe String
        }

derive instance newtypeState :: Newtype State _
derive instance eqState :: Eq State
instance showState :: Show State where
  show :: State -> String
  show (State { slots: slots, name: name}) = "State { slots: " <> show slots <> ", name: " <> show name <> " }"

instance decodeState :: DecodeJson State where
  decodeJson :: Json -> Either String State
  decodeJson json = do
    obj <- decodeJson json
    slots <- getField obj "slots"
    name <- getFieldOptional obj "name"
    pure $ State { slots: slots
                 , name: name
                 }

instance encodeState :: EncodeJson State where
  encodeJson :: State -> Json
  encodeJson state
    = encodeJson
      ( "slots" := (unwrap state).slots
      ~> "name" := (unwrap state).name
      ~> jsonEmptyObject
      )

initialState :: State
initialState = State { slots : [], name : Nothing }

changeSlots :: (Array Slot -> Array Slot) -> State -> State
changeSlots changer state =
  State { slots: changer (unwrap state).slots
        , name: (unwrap state).name
        }

changeName :: String -> State -> State
changeName name state
  = State { slots: (unwrap state).slots
          , name: Just name
          }
