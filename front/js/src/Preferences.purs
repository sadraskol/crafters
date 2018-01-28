module Preferences (DomainEvent(..), applyEvent) where

import Prelude

import Activity (Activity, toggleActivity)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Unsafe (unsafePerformEff)
import Data.Date (Date)
import Data.DateTime.Instant (Instant)
import Data.Newtype (unwrap)
import Data.Set (isEmpty)
import Slot (Slot, TimeSlot, toggleDate, toggleSingle, toggleTimeSlot)
import State (State, changeSlots, changeActivity, validateSlots, validateActivities, validateLastSubmit, changeLastSubmit)
import StaticProps (StaticProps)

data DomainEvent eff
  = SingleToggle Slot
  | DateToggle Date
  | TimeSlotToggle TimeSlot (Array Date)
  | ActivityToggle Activity
  | Submit Instant (StaticProps -> State -> Eff eff Unit)

applyEvent :: StaticProps -> DomainEvent _ -> State -> State
applyEvent _ (SingleToggle slot) state = validateSlots $ changeSlots (toggleSingle slot) state
applyEvent _ (DateToggle date) state = validateSlots $ changeSlots (toggleDate date) state
applyEvent _ (TimeSlotToggle timeslot range) state = validateSlots $ changeSlots (toggleTimeSlot timeslot range) state
applyEvent _ (ActivityToggle activity) state = validateActivities $ changeActivity (toggleActivity activity) state
applyEvent props (Submit instant handler) state = doRequest handler instant props $ validate instant state

validate :: Instant -> State -> State
validate instant = validateActivities <<< validateSlots <<< validateLastSubmit instant

doRequest :: (StaticProps -> State -> Eff _ Unit) -> Instant -> StaticProps -> State -> State
doRequest handler nowInstant props state
  = if isEmpty (unwrap state).errors
    then unsafePerformEff do
      handler props state
      pure $ changeLastSubmit nowInstant state
    else state
