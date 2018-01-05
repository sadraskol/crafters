module Components.ActivityPicker where

import Components.Container (Action(..))
import Data.Foldable (any)
import Data.Newtype (unwrap)
import Preferences (Event(..))
import Prelude (($), (==))
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import State (Activity(LunchDojo, EveningDojo, DDD), State)

render :: _ -> State -> ReactElement
render dispatch state = R.ul [ ulStyle ] [
    R.li' [ R.label' [ (R.input [ RP._type "checkbox" , RP.checked $ isChecked DDD, RP.onClick \_ -> dispatch $ Preference $ ActivityToggle $ DDD] []), R.text " DDD" ]]
  , R.li' [ R.label' [ (R.input [ RP._type "checkbox" , RP.checked $ isChecked EveningDojo, RP.onClick \_ -> dispatch $ Preference $ ActivityToggle $ EveningDojo] []), R.text " Coding dojo du soir" ]]
  , R.li' [ R.label' [ (R.input [ RP._type "checkbox" , RP.checked $ isChecked LunchDojo, RP.onClick \_ -> dispatch $ Preference $ ActivityToggle $ LunchDojo] []), R.text " Coding dojo du midi" ]]
  ]

  where
    ulStyle = RP.style { "list-style": "none", "padding": 0 }

    isChecked activity = any (\a -> a == activity) (unwrap state).activities
