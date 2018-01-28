module Components.ActivityPicker where

import Activity (Activity(LunchDojo, EveningDojo, DDD))
import Data.Foldable (any)
import Data.Newtype (unwrap)
import Data.Set (member)
import Preferences (DomainEvent(..))
import Prelude (($), (<>), (==))
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import State (Error(..), State)

render :: _ -> State -> ReactElement
render dispatch state = R.div [RP.className "field"] $ [
  R.div [RP.className "control"] [
    R.ul [ ulStyle ] $ [
        R.li' [ R.label [RP.style { cursor: "pointer" }] [ (R.input [ RP._type "checkbox", RP.checked $ isChecked DDD, RP.onChange \_ -> dispatch $ ActivityToggle $ DDD] []), R.text " DDD" ]]
      , R.li' [ R.label [RP.style { cursor: "pointer" }] [ (R.input [ RP._type "checkbox", RP.checked $ isChecked EveningDojo, RP.onChange \_ -> dispatch $ ActivityToggle $ EveningDojo] []), R.text " Coding dojo du soir" ]]
      , R.li' [ R.label [RP.style { cursor: "pointer" }] [ (R.input [ RP._type "checkbox", RP.checked $ isChecked LunchDojo, RP.onChange \_ -> dispatch $ ActivityToggle $ LunchDojo] []), R.text " Coding dojo du midi" ]]
      ]
    ]
  ] <> errorMessage

  where
    ulStyle = RP.style { listStyle: "none", "padding": 0 }

    isChecked activity = any (\a -> a == activity) (unwrap state).activities

    fieldHasError = member NoActivity (unwrap state).errors
    errorMessage = if fieldHasError
                   then [R.p [RP.className "help is-danger"] [R.text "Choisissez au moins une activité"]]
                   else []
