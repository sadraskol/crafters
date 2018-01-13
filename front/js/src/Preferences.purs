module Preferences ( DomainEvent(..)
                   , applyEvent
                   , slotsFromDates
                   , removeTimeSlot
                   , removeSlot
                   , removeDate
                   ) where

import Prelude

import Activity (Activity)
import Control.Monad.Aff (launchAff_)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Unsafe (unsafePerformEff)
import DOM.HTML (window)
import DOM.HTML.Location (assign)
import DOM.HTML.Window (location)
import Data.Argonaut.Encode (encodeJson)
import Data.Array (concatMap, filter, foldr, insert)
import Data.Date (Date)
import Data.Foldable (any)
import Data.Newtype (unwrap)
import Network.HTTP.Affjax (post_)
import Network.HTTP.StatusCode (StatusCode(..))
import Slot (Slot(..), TimeSlot(..))
import State (State, addActivity, changeName, changeSlots, initialState, removeActivity)
import StaticProps (StaticProps)

data DomainEvent
  = SingleToggle Slot
  | DateToggle Date
  | TimeSlotToggle TimeSlot (Array Date)
  | ActivityToggle Activity
  | Name String
  | Submit

applyEvent :: StaticProps -> DomainEvent -> State -> State
applyEvent _ (SingleToggle slot) state = if any (eq slot) (unwrap state).slots
  then removeSlot slot state
  else changeSlots (insert slot) state
applyEvent _ (DateToggle date) state = if any (\(Slot d _) -> d == date) (unwrap state).slots
  then removeDate date state
  else changeSlots (\slots -> foldr insert slots ((Slot date) <$> [Lunch, Evening])) state
applyEvent _ (TimeSlotToggle timeslot range) state = if any (\(Slot _ t) -> t == timeslot) (unwrap state).slots
  then removeTimeSlot timeslot state
  else changeSlots (\slots -> foldr insert slots ((\d -> Slot d timeslot) <$> range)) state
applyEvent _ (ActivityToggle activity) state = if any (\a -> a == activity) (unwrap state).activities
  then removeActivity activity state
  else addActivity activity state
applyEvent props Submit state = doRequest props state
applyEvent _ (Name name) state = changeName name state

doRequest :: StaticProps -> State -> State
doRequest props state = unsafePerformEff do
  launchAff_ do
      response <- post_ ("/api/preferences/" <> monthId) (encodeJson state)
      case response of
        {status: StatusCode 200} -> do
          liftEff $ (assign $ "/months/" <> monthId) =<< (location =<< window)
        _ -> do
          log "failure"

  pure state

      where
      monthId :: String
      monthId = (unwrap props).id

slotsFromDates :: Array Date -> State
slotsFromDates arr = changeSlots (const $ range arr) initialState
    where
      range :: Array Date -> Array Slot
      range = concatMap (\date -> [ Slot date Lunch, Slot date Evening ])

removeTimeSlot :: TimeSlot -> State -> State
removeTimeSlot timeslot = changeSlots $ filter (\(Slot _d t) -> t /= timeslot)

removeSlot :: Slot -> State -> State
removeSlot slot = changeSlots $ filter (\s-> s /= slot)

removeDate :: Date -> State -> State
removeDate date = changeSlots $ filter (\(Slot d _t) -> d /= date)
