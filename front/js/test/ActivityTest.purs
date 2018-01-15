module ActivityTest (activityTests) where

import Prelude

import Activity (Activity(..), toggleActivity)
import Control.Monad.Free (Free)
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert

activityTests :: forall e. Free (TestF e) Unit
activityTests = do
  suite "Activity" do
    suite "toggle activity" do
      test "when the activity is not member, adds it" do
        let activities = [DDD]
        let expected = [DDD, LunchDojo]
        let actual = toggleActivity LunchDojo activities
        Assert.equal expected actual

      test "when the activity is member, removes it" do
        let activities = [DDD, LunchDojo]
        let expected = [LunchDojo]
        let actual = toggleActivity DDD activities
        Assert.equal expected actual
