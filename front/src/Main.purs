module Main where

import Prelude

import Calendar (getWeekdaysInRange, getDate)
import Control.Monad.Aff.Console (CONSOLE, log)
import Control.Monad.Eff (Eff)
import Control.Monad.Trans.Class (lift)
import DOM (DOM)
import Data.Array (delete, elem, insert)
import Data.Date (Date)
import Data.Date as Date
import Data.Enum (fromEnum)
import React.DOM as R
import React.DOM.Props as RP
import Slot (Slot(..), TimeSlot(..))
import Thermite as T
import ThermiteUtils (defaultMain)

data Action
  = Submit
  | SingleToggle Slot

type State = Array Slot

range :: Array Date
range = getWeekdaysInRange (getDate 2017 Date.February 27) (getDate 2017 Date.March 29)

initialState :: State
initialState = []

render :: forall a. T.Render State a Action
render dispatch _ state _ =
  [ R.table [] [
      R.tbody [] [
        R.tr [] ([R.td' []] <> (dateCell <$> range)),
        R.tr [] ([R.td' [R.text "Lunch"]] <> (lunchCell <$> range)),
        R.tr [] ([R.td' [R.text "Evening"]] <> (eveningCell <$> range))
      ]
    ],
    R.ul' $ (\slot -> R.li' [R.text $ show slot]) <$> state,
    R.button [RP.onClick \_ -> dispatch $ Submit] [R.text "Valider"]
  ]

  where
    lunchCell date = R.td [] [R.input [ RP._type "checkbox"
                                 , RP.onClick \_ -> dispatch $ SingleToggle (Slot date Lunch)
                                 ] []]
    eveningCell date = R.td [] [R.input [ RP._type "checkbox"
                                   , RP.onClick \_ -> dispatch $ SingleToggle (Slot date Evening)
                                   ] []]
    dateCell date = R.td [] [R.text $ dateToString date]
    dateToString date = (frenchWeekday $ Date.weekday date) <> " " <> (show $ fromEnum $ Date.day date)
    frenchWeekday :: Date.Weekday -> String
    frenchWeekday Date.Monday = "Lundi"
    frenchWeekday Date.Tuesday = "Mardi"
    frenchWeekday Date.Wednesday = "Mercredi"
    frenchWeekday Date.Thursday = "Jeudi"
    frenchWeekday Date.Friday = "Vendredi"
    frenchWeekday _ = "???"

performAction :: forall a e. T.PerformAction (console :: CONSOLE | e) State a Action
performAction (SingleToggle slot) _ _ = void $ T.cotransform (\state -> if elem slot state then delete slot state else insert slot state)
performAction Submit _ _ = do
  lift $ log "Submit"
  void $ T.cotransform id

spec :: forall a e. T.Spec (console :: CONSOLE | e) State a Action
spec = T.simpleSpec performAction render

main :: forall e. Eff ( console :: CONSOLE, dom :: DOM | e ) Unit
main = defaultMain spec initialState unit
