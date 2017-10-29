module SlotTestSuite(slotTests) where

import Prelude

import Calendar (getDate)
import Control.Monad.Free (Free)
import Data.Date as Date
import Slot (Slot(..), TimeSlot(..), slotsFromDates, filterTimeSlot, removeSlot, removeDate)
import Test.Unit (TestF, suite, test)
import Test.Unit.Assert as Assert

someSlots :: Array Slot
someSlots = [ Slot (getDate 2017 Date.February 27) Lunch
            , Slot (getDate 2017 Date.February 27) Evening
            , Slot (getDate 2017 Date.March 8) Lunch
            , Slot (getDate 2017 Date.March 8) Evening
            ]

slotTests :: forall e. Free (TestF e) Unit
slotTests = do
  suite "Slot" do
    test "generate every possible slot from range" do
      let dates  = [ getDate 2017 Date.February 27
                   , getDate 2017 Date.March 8
                   ]
      let actual = slotsFromDates dates
      Assert.equal someSlots actual

    test "correctly implements Ord" do
      let d1 = getDate 2017 Date.February 23
      let d2 = getDate 2016 Date.March 3
      Assert.assert "dates goes first" (Slot d1 Lunch > Slot d2 Evening)
      Assert.assert "Lunch < Evening" (Slot d1 Lunch < Slot d1 Evening)

    test "removing all timeslots from a range" do
      let expected = [ Slot (getDate 2017 Date.February 27) Evening
                     , Slot (getDate 2017 Date.March 8) Evening
                     ]
      Assert.equal expected (filterTimeSlot Lunch someSlots)

    test "remove a date from a range" do
      let expected = [ Slot (getDate 2017 Date.February 27) Lunch
                     , Slot (getDate 2017 Date.February 27) Evening
                     ]
      Assert.equal expected (removeDate (getDate 2017 Date.March 8) someSlots)

    test "remove a single slot from a range" do
      let expected = [ Slot (getDate 2017 Date.February 27) Lunch
                     , Slot (getDate 2017 Date.February 27) Evening
                     , Slot (getDate 2017 Date.March 8) Lunch
                     ]
      Assert.equal expected (removeSlot (Slot (getDate 2017 Date.March 8) Evening) someSlots)
