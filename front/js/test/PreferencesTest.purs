module PreferencesTest(preferencesTests) where

import Prelude

import Calendar (getDate)
import Control.Monad.Free (Free)
import Data.Date as Date
import Data.Maybe (Maybe(..))
import Preferences (Event(..), applyPreferences, removeSlot)
import State (State(..))
import Slot (Slot(..), TimeSlot(..))
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert

someSlots :: Array Slot
someSlots = [ Slot (getDate 2017 Date.February 27) Lunch
            , Slot (getDate 2017 Date.February 27) Evening
            , Slot (getDate 2017 Date.March 8) Lunch
            , Slot (getDate 2017 Date.March 8) Evening
            ]

defState :: Array Slot -> State
defState arr = State {slots: arr, name: Nothing}

preferencesTests :: forall e. Free (TestF e) Unit
preferencesTests = do
  suite "Preferences" do
    suite "SingleToggle" do
      test "Remove slot if toggled and already existed" do
        let slot = Slot (getDate 2017 Date.March 8) Lunch
        let actual = applyPreferences (SingleToggle slot) (defState someSlots)
        let expected = removeSlot slot (defState someSlots)
        Assert.equal expected actual

      test "Add slot if toggled and didn't exist" do
        let slot = Slot (getDate 2017 Date.March 8) Lunch
        let state = removeSlot slot (defState someSlots)
        let actual = applyPreferences (SingleToggle slot) state
        Assert.equal (defState someSlots) actual

    suite "DateToggle" do
      test "Add all timeslot for a date preference" do
        let state = [ Slot (getDate 2017 Date.February 27) Lunch
                    , Slot (getDate 2017 Date.February 27) Evening
                    ]
        let date = getDate 2017 Date.March 8
        let actual = applyPreferences (DateToggle date) (defState state)
        Assert.equal (defState someSlots) actual

      test "remove all timeslot for a date preference" do
        let expected = [ Slot (getDate 2017 Date.February 27) Lunch
                       , Slot (getDate 2017 Date.February 27) Evening
                       ]
        let date = getDate 2017 Date.March 8
        let actual = applyPreferences (DateToggle date) (defState someSlots)
        Assert.equal (defState expected) actual

      test "one timeslot, it should remove it" do
        let state = [ Slot (getDate 2017 Date.February 27) Lunch
                    , Slot (getDate 2017 Date.February 27) Evening
                    , Slot (getDate 2017 Date.March 8) Lunch
                    ]
        let expected = [ Slot (getDate 2017 Date.February 27) Lunch
                       , Slot (getDate 2017 Date.February 27) Evening
                       ]
        let date = getDate 2017 Date.March 8
        let actual = applyPreferences (DateToggle date) (defState state)
        Assert.equal (defState expected) actual

    suite "TimeSlotToggle" do
      test "remove all slots for a timeslot preference" do
        let dateRange = [getDate 2017 Date.February 27 , getDate 2017 Date.March 8]
        let expected = [ Slot (getDate 2017 Date.February 27) Lunch
                       , Slot (getDate 2017 Date.March 8) Lunch
                       ]
        let actual = applyPreferences (TimeSlotToggle Evening dateRange) (defState someSlots)
        Assert.equal (defState expected) actual

      test "remove all slots for a timeslot preference" do
        let dateRange = [getDate 2017 Date.February 27 , getDate 2017 Date.March 8]
        let state = [Slot (getDate 2017 Date.February 27) Lunch]
        let expected = [ Slot (getDate 2017 Date.February 27) Lunch
                       , Slot (getDate 2017 Date.February 27) Evening
                       , Slot (getDate 2017 Date.March 8) Evening
                       ]
        let actual = applyPreferences (TimeSlotToggle Evening dateRange) (defState state)
        Assert.equal (defState expected) actual
