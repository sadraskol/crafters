module SubmitTest where

import Prelude

import Activity (Activity(..))
import Calendar (getDate)
import Control.Monad.Aff.Console (logShow)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Now (now)
import Control.Monad.Free (Free)
import Data.Date (Month(..))
import Data.DateTime.Instant (instant, unInstant)
import Data.Maybe (fromMaybe)
import Data.Newtype (unwrap)
import Data.Set (empty, fromFoldable)
import Data.Time.Duration (Milliseconds(Milliseconds))
import Preferences (DomainEvent(..), applyEvent)
import Slot (Slot(..), TimeSlot(..))
import State (State(..))
import StaticProps (StaticProps(..))
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert

someSlot :: Slot
someSlot = Slot (getDate 2017 March 8) Evening

noop :: forall a b. a -> b -> Eff _ Unit
noop _a _b = pure unit

props :: StaticProps
props = StaticProps { id: "", range: [], csrf_token: "" }

state :: State
state = State { slots: [someSlot], activities: fromFoldable [DDD], errors: empty, lastSubmit: bottom}

submitTests :: Free (TestF _) Unit
submitTests =
  suite "Double submit" do
    test "unrelated submits are ignored" do
      nowInstant <- liftEff $ now
      let newState = applyEvent props (Submit nowInstant noop) state
      Assert.shouldEqual (unwrap newState).lastSubmit nowInstant

    test "closed submit (< 1sec) should not be taken to account" do
      nowInstant <- liftEff $ now
      let closeNow = fromMaybe top $ instant (unInstant nowInstant + Milliseconds 200.0)
      let interState = applyEvent props (Submit nowInstant noop) state
      let newState = applyEvent props (Submit closeNow noop) interState
      Assert.shouldEqual (unwrap newState).lastSubmit nowInstant
