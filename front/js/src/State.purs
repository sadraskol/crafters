module State (State(..), Error(..), initialState, changeSlots, changeActivity, changeLastSubmit, validateSlots, validateActivities, validateLastSubmit) where

import Prelude

import Activity (Activity)
import Data.Argonaut.Core (Json, jsonEmptyObject)
import Data.Argonaut.Decode (class DecodeJson, decodeJson, getField)
import Data.Argonaut.Encode (class EncodeJson, encodeJson, (:=), (~>))
import Data.DateTime.Instant (Instant, unInstant)
import Data.Either (Either)
import Data.Enum (enumFromTo)
import Data.Newtype (class Newtype, unwrap)
import Data.Set (Set, delete, empty, fromFoldable, insert, isEmpty, toUnfoldable)
import Data.Time.Duration (Milliseconds(..))
import Slot (Slot)

data Error
  = NoActivity
  | NoSlot
  | TooSoon

derive instance eqError :: Eq Error
derive instance ordError :: Ord Error
instance showError :: Show Error where
  show :: Error -> String
  show NoActivity = "Pas d'activité"
  show NoSlot = "Pas de créneau"
  show TooSoon = "Trop rapide"

newtype State =
  State { slots :: Array Slot
        , activities :: Set Activity
        , errors :: Set Error
        , lastSubmit :: Instant
        }

derive instance newtypeState :: Newtype State _
derive instance eqState :: Eq State

instance showState :: Show State where
  show :: State -> String
  show (State {slots: slots, activities: activities, errors: errors, lastSubmit: lastSubmit})
    = "State { slots: " <> show slots <>
      ", activities: " <> show activities <>
      ", errors: " <> show errors <>
      ", lastSubmit: " <> show lastSubmit <>
      " }"

instance decodeState :: DecodeJson State where
  decodeJson :: Json -> Either String State
  decodeJson json = do
    obj <- decodeJson json
    slots <- getField obj "slots"
    activities <- fromArray <$> getField obj "activities"
    pure $ State { slots: slots
                 , activities: activities
                 , errors: empty
                 , lastSubmit: bottom
                 }

      where
        fromArray :: Array Activity -> Set Activity
        fromArray activities = fromFoldable activities

instance encodeState :: EncodeJson State where
  encodeJson :: State -> Json
  encodeJson state
    = encodeJson
      ( "slots" := (unwrap state).slots
      ~> "activities" := activities
      ~> jsonEmptyObject
      )
      where
        activities :: Array Activity
        activities = toUnfoldable (unwrap state).activities

initialState :: State
initialState = State { slots: [], activities: fromFoldable allActivities, errors: empty, lastSubmit: bottom }
  where
    allActivities :: Array Activity
    allActivities = enumFromTo bottom top

changeSlots :: (Array Slot -> Array Slot) -> State -> State
changeSlots changer state =
  State { slots: changer (unwrap state).slots
        , activities: (unwrap state).activities
        , errors: (unwrap state).errors
        , lastSubmit: (unwrap state).lastSubmit
        }

changeActivity :: (Set Activity -> Set Activity) -> State -> State
changeActivity changer state
  = State { slots: (unwrap state).slots
          , activities: changer (unwrap state).activities
          , errors: (unwrap state).errors
          , lastSubmit: (unwrap state).lastSubmit
          }

changeErrors :: (Set Error -> Set Error) -> State -> State
changeErrors changer state
  = State { slots: (unwrap state).slots
          , activities: (unwrap state).activities
          , errors: changer (unwrap state).errors
          , lastSubmit: (unwrap state).lastSubmit
          }

changeLastSubmit :: Instant -> State -> State
changeLastSubmit change state
  = State { slots: (unwrap state).slots
          , activities: (unwrap state).activities
          , errors: (unwrap state).errors
          , lastSubmit: change
          }

validateSlots :: State -> State
validateSlots state
  = if (unwrap state).slots == []
    then changeErrors (insert NoSlot) state
    else changeErrors (delete NoSlot) state

validateActivities :: State -> State
validateActivities state
  = if isEmpty (unwrap state).activities
    then changeErrors (insert NoActivity) state
    else changeErrors (delete NoActivity) state

validateLastSubmit :: Instant -> State -> State
validateLastSubmit nowInstant state
  = if (unInstant nowInstant - Milliseconds 1000.0) <= unInstant (unwrap state).lastSubmit
    then changeErrors (insert TooSoon) state
    else changeErrors (delete TooSoon) state
