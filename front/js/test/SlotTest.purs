module SlotTest (slotTests) where

import Prelude

import Calendar (getDate)
import Control.Monad.Free (Free)
import Data.Date as Date
import Slot (Slot(..), TimeSlot(..), toggleSingle, toggleDate, toggleTimeSlot)
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert

slotA :: Slot
slotA = Slot (getDate 2017 Date.February 27) Lunch
slotB :: Slot
slotB = Slot (getDate 2017 Date.February 27) Evening
slotC :: Slot
slotC = Slot (getDate 2017 Date.March 8) Lunch
slotD :: Slot
slotD = Slot (getDate 2017 Date.March 8) Evening

someSlots :: Array Slot
someSlots = [ slotA, slotB, slotC, slotD ]

slotTests :: forall e. Free (TestF e) Unit
slotTests = do
  suite "slot tests" do
    suite "toggle single slot" do
      test "Remove slot if toggled and already existed" do
        let slot = slotC
        let actual = toggleSingle slot someSlots
        let expected = [ slotA, slotB, slotD ]
        Assert.equal expected actual
      test "Add slot if toggled and didn't exist" do
        let slot = slotC
        let slots = [ slotA, slotB, slotD ]
        let actual = toggleSingle slot slots
        Assert.equal someSlots actual

    suite "toggle for a date" do
      test "Add all timeslot for a date" do
        let slots = [ slotA, slotB ]
        let date = getDate 2017 Date.March 8
        let actual = toggleDate date slots
        Assert.equal someSlots actual

      test "remove all timeslot for a date" do
        let expected = [ slotA, slotB ]
        let date = getDate 2017 Date.March 8
        let actual = toggleDate date someSlots
        Assert.equal expected actual

      test "one timeslot, it should remove it" do
        let slots = [ slotA, slotB, slotC ]
        let expected = [ slotA, slotB ]
        let date = getDate 2017 Date.March 8
        let actual = toggleDate date slots
        Assert.equal expected actual

    suite "toggle for a time of the day" do
      test "remove all slots for a timeslot" do
        let dateRange = [getDate 2017 Date.February 27 , getDate 2017 Date.March 8]
        let expected = [ slotA, slotC ]
        let actual = toggleTimeSlot Evening dateRange someSlots
        Assert.equal expected actual

      test "remove all slots for a timeslot" do
        let dateRange = [getDate 2017 Date.February 27 , getDate 2017 Date.March 8]
        let slots = [slotA]
        let expected = [ slotA, slotB, slotD]
        let actual = toggleTimeSlot Evening dateRange slots
        Assert.equal expected actual
