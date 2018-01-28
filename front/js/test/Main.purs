module Test.Main where

import Prelude

import ActivityTest (activityTests)
import CalendarTest (calendarTests)
import Control.Monad.Eff (Eff)
import SlotTest (slotTests)
import SubmitTest (submitTests)
import Test.Unit.Main (runTest)

main :: Eff _ Unit
main = runTest do
  slotTests
  calendarTests
  activityTests
  submitTests
