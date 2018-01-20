module Preferences (DomainEvent(..), applyEvent) where

import Prelude

import Activity (Activity, toggleActivity)
import Control.Monad.Aff (launchAff_)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Unsafe (unsafePerformEff)
import DOM.HTML (window)
import DOM.HTML.Location (assign)
import DOM.HTML.Window (location)
import Data.Argonaut.Encode (encodeJson)
import Data.Date (Date)
import Data.Newtype (unwrap)
import Data.Set (isEmpty)
import Network.HTTP.Affjax (post_)
import Network.HTTP.StatusCode (StatusCode(..))
import Slot (Slot, TimeSlot, toggleDate, toggleSingle, toggleTimeSlot)
import State (State, changeName, changeSlots, changeActivity, validateName, validateSlots, validateActivities)
import StaticProps (StaticProps)

data DomainEvent
  = SingleToggle Slot
  | DateToggle Date
  | TimeSlotToggle TimeSlot (Array Date)
  | ActivityToggle Activity
  | Name String
  | Submit

applyEvent :: StaticProps -> DomainEvent -> State -> State
applyEvent _ (SingleToggle slot) state = validateSlots $ changeSlots (toggleSingle slot) state
applyEvent _ (DateToggle date) state = validateSlots $ changeSlots (toggleDate date) state
applyEvent _ (TimeSlotToggle timeslot range) state = validateSlots $  changeSlots (toggleTimeSlot timeslot range) state
applyEvent _ (ActivityToggle activity) state = validateActivities $ changeActivity (toggleActivity activity) state
applyEvent props Submit state = doRequest props state
applyEvent _ (Name name) state = validateName $ changeName name state

doRequest :: StaticProps -> State -> State
doRequest props state
  = if isEmpty (unwrap state).errors
    then
      unsafePerformEff do
        launchAff_ do
            response <- post_ ("/api/preferences/" <> monthId) (encodeJson state)
            case response of
              {status: StatusCode 200} -> do
                liftEff $ (assign $ "/months/" <> monthId) =<< (location =<< window)
              _ -> do
                log "failure"

        pure state
    else state

      where
      monthId :: String
      monthId = (unwrap props).id
