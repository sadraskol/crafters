module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.AVar (AVAR)

import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Assert as Assert

import Data.Enum (toEnum)
import Data.Date as Date
import Data.Maybe (fromJust)

import Partial.Unsafe (unsafePartial)

import Calendar (getWeekdaysInRange)

import Slot (Slot(..), TimeSlot(..), slotsFromDates)

type Tests = Eff (console :: CONSOLE , testOutput :: TESTOUTPUT , avar :: AVAR) Unit

getDate :: Int -> Date.Month -> Int -> Date.Date
getDate year month day = unsafePartial fromJust $ Date.canonicalDate <$> toEnum year <*> pure month <*> toEnum day

someSlots :: Array Slot
someSlots = [ Slot Lunch (getDate 2017 Date.February 27)
            , Slot Evening (getDate 2017 Date.February 27)
            , Slot Lunch (getDate 2017 Date.March 8)
            , Slot Evening (getDate 2017 Date.March 8)
            ]

main :: Tests
main = runTest do
  suite "Generate full days for the time range" do
    test "Remove weekends from the range" do
      let expected  = [ getDate 2017 Date.February 27
                      , getDate 2017 Date.February 28
                      , getDate 2017 Date.March 1
                      , getDate 2017 Date.March 2
                      , getDate 2017 Date.March 3
                      , getDate 2017 Date.March 6
                      , getDate 2017 Date.March 7
                      , getDate 2017 Date.March 8
                      , getDate 2017 Date.March 9
                      , getDate 2017 Date.March 10
                      , getDate 2017 Date.March 13
                      , getDate 2017 Date.March 14
                      , getDate 2017 Date.March 15
                      , getDate 2017 Date.March 16
                      , getDate 2017 Date.March 17
                      , getDate 2017 Date.March 20
                      , getDate 2017 Date.March 21
                      , getDate 2017 Date.March 22
                      , getDate 2017 Date.March 23
                      , getDate 2017 Date.March 24
                      , getDate 2017 Date.March 27
                      , getDate 2017 Date.March 28
                      , getDate 2017 Date.March 29
                      ]
      let actual = getWeekdaysInRange (getDate 2017 Date.February 27) (getDate 2017 Date.March 29)
      Assert.equal expected actual
  suite "Slot" do
    test "generate every possible slot from range" do
      let dates  = [ getDate 2017 Date.February 27
                   , getDate 2017 Date.March 8
                   ]
      let actual = slotsFromDates dates
      Assert.equal someSlots actual
