module Main where

import Prelude

import Calendar (getWeekdaysInRange, getDate, frenchWeekday)
import Control.Monad.Aff.Console (CONSOLE, log)
import Control.Monad.Eff (Eff)
import Control.Monad.Trans.Class (lift)
import DOM (DOM)
import Data.Array (any)
import Data.Date (Date)
import Data.Date as Date
import Data.Enum (fromEnum)
import Preferences (Event(..), applyPreferences)
import React.DOM as R
import React.DOM.Props as RP
import Slot (Slot(..), TimeSlot(..))
import Thermite as T
import ThermiteUtils (defaultMain)

data Action
  = Submit
  | Preference Event

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
        R.tr [] ([R.td [ RP.onClick \_ -> dispatch $ Preference $ TimeSlotToggle Lunch range
                       ] [R.text "Repas"]] <> (lunchCell <$> range)),
        R.tr [] ([R.td [ RP.onClick \_ -> dispatch $ Preference $ TimeSlotToggle Evening range
                       ] [R.text "Soirée"]] <> (eveningCell <$> range))
      ]
    ],
    R.ul' $ (\slot -> R.li' [R.text $ show slot]) <$> state,
    R.button [RP.onClick \_ -> dispatch $ Submit] [R.text "Valider"]
  ]

  where
    lunchCell date = R.td [] [R.input [ RP._type "checkbox"
                                 , RP.checked $ any (eq $ Slot date Lunch) state
                                 , RP.onClick \_ -> dispatch $ Preference $ SingleToggle $ Slot date Lunch
                                 ] []]
    eveningCell date = R.td [] [R.input [ RP._type "checkbox"
                                   , RP.checked $ any (eq $ Slot date Evening) state
                                   , RP.onClick \_ -> dispatch $ Preference $ SingleToggle $ Slot date Evening
                                   ] []]
    dateCell date = R.td [RP.onClick \_ -> dispatch $ Preference $ DateToggle date] [R.text $ dateToString date]
    dateToString date = (frenchWeekday $ Date.weekday date) <> " " <> (show $ fromEnum $ Date.day date)

performAction :: forall a e. T.PerformAction (console :: CONSOLE | e) State a Action
performAction (Preference event) _ _ = void $ T.cotransform $ applyPreferences event
performAction Submit _ _ = do
  lift $ log "Submit"
  void $ T.cotransform id

spec :: forall a e. T.Spec (console :: CONSOLE | e) State a Action
spec = T.simpleSpec performAction render

main :: forall e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
main = defaultMain spec initialState unit
