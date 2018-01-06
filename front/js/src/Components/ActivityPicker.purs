module Components.ActivityPicker where

import Data.Foldable (any)
import Data.Newtype (unwrap)
import Preferences (DomainEvent(..))
import Prelude (($), (==))
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import State (State)
import Activity (Activity(LunchDojo, EveningDojo, DDD))

render :: _ -> State -> ReactElement
render dispatch state = R.ul [ ulStyle ] [
    R.li' [ R.label' [ (R.input [ RP._type "checkbox" , RP.checked $ isChecked DDD, RP.onClick \_ -> dispatch $ ActivityToggle $ DDD] []), R.text " DDD" ]]
  , R.li' [ R.label' [ (R.input [ RP._type "checkbox" , RP.checked $ isChecked EveningDojo, RP.onClick \_ -> dispatch $ ActivityToggle $ EveningDojo] []), R.text " Coding dojo du soir" ]]
  , R.li' [ R.label' [ (R.input [ RP._type "checkbox" , RP.checked $ isChecked LunchDojo, RP.onClick \_ -> dispatch $ ActivityToggle $ LunchDojo] []), R.text " Coding dojo du midi" ]]
  ]

  where
    ulStyle = RP.style { "list-style": "none", "padding": 0 }

    isChecked activity = any (\a -> a == activity) (unwrap state).activities
