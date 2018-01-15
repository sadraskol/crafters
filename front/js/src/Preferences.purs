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
import Network.HTTP.Affjax (post_)
import Network.HTTP.StatusCode (StatusCode(..))
import Slot (Slot, TimeSlot, toggleDate, toggleSingle, toggleTimeSlot)
import State (State, changeName, changeSlots, changeActivity)
import StaticProps (StaticProps)

data DomainEvent
  = SingleToggle Slot
  | DateToggle Date
  | TimeSlotToggle TimeSlot (Array Date)
  | ActivityToggle Activity
  | Name String
  | Submit

applyEvent :: StaticProps -> DomainEvent -> State -> State
applyEvent _ (SingleToggle slot) state = changeSlots (toggleSingle slot) state
applyEvent _ (DateToggle date) state = changeSlots (toggleDate date) state
applyEvent _ (TimeSlotToggle timeslot range) state = changeSlots (toggleTimeSlot timeslot range) state
applyEvent _ (ActivityToggle activity) state = changeActivity (toggleActivity activity) state
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
