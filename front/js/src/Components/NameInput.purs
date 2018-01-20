module Components.NameInput where

import Data.Newtype (unwrap)
import Data.Set (member)
import Preferences (DomainEvent(..))
import Prelude (($), (<>))
import React (Event, ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import State (Error(..), State)
import Thermite (EventHandler)
import Unsafe.Coerce (unsafeCoerce)

render :: _ -> State -> ReactElement
render dispatch state
  = R.div [RP.className "field is-horizontal"] [
    R.div [RP.className "field-label is-normal"] [
      R.label [RP.className "label"] [R.text "Ton nom: "]
    ],
    R.div [RP.className "field-body"] [
      R.div [RP.className "field"] $ [
        R.div [RP.className "control"] [
          R.input [ RP.value (unwrap state).name
                  , RP.onChange $ dispatchName dispatch
                  , RP.className inputClasses ] []
        ]
      ] <> errorMessage
    ]
  ]

  where
    fieldHasError = member EmptyName (unwrap state).errors
    errorMessage = if fieldHasError
                   then [R.p [RP.className "help is-danger"] [R.text "Prière de rentrer un nom"]]
                   else []

    inputClasses = if fieldHasError
                   then "input is-danger"
                   else "input"

dispatchName :: (DomainEvent -> EventHandler) -> Event -> EventHandler
dispatchName dispatch e = dispatch $ Name (unsafeCoerce e).target.value
