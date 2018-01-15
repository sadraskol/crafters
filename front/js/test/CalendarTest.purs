module CalendarTest (calendarTests) where

import Prelude

import Calendar (getDate, getWeekdaysInRange)
import Control.Monad.Free (Free)
import Test.Unit (TestF, suite, test)

import Test.Unit.Assert as Assert

import Data.Date as Date

calendarTests :: forall e. Free (TestF e) Unit
calendarTests = do
  suite "Calendar" do
    test "generate full days for the time range Remove weekends from the range" do
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
