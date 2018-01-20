module Main where

import Components.ActivityPicker as ActivityPicker
import Components.DateTitle as DateTitle
import Components.NameInput as NameInput
import Components.SlotCell as SlotCell
import Components.TimeSlotTitle as TimeSlotTitle
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Date (Date)
import Data.Either (Either(..))
import Data.Newtype (unwrap)
import Data.Set (member)
import Preferences (DomainEvent(..), applyEvent)
import Prelude (Unit, bind, discard, void, ($), (<$>), (<>), (=<<))
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (TimeSlot(..))
import State (Error(..), State, initialState)
import StaticProps (StaticProps(..), getInitProps)
import Thermite as T
import ThermiteUtils (defaultMain)

render :: T.Render State StaticProps DomainEvent
render dispatch props state _ =
  [ R.div [RP.className "is-flex"]
    [ R.aside' [
        R.ul' [
          R.li [RP.className "table-header"] [],
          TimeSlotTitle.render Lunch range dispatch state,
          TimeSlotTitle.render Evening range dispatch state
        ]
      ],
      R.ul [RP.className "is-flex"] (renderRow <$> range)
    ],
    errorMessage,
    ActivityPicker.render dispatch state,
    R.div [RP.className "is-not-expanded"] [
      NameInput.render dispatch state,
      R.div [RP.className "field is-grouped is-grouped-right"] [
        R.p [RP.className "control"] [
          R.button [
            RP.onClick \_ -> dispatch Submit,
            RP.className "button is-primary"] [R.text "Valider"]
        ]
      ]
    ]
  ]

  where
    range :: Array Date
    range = (unwrap props).range

    renderRow :: Date -> ReactElement
    renderRow date = R.li [ RP.style {"min-width": 45, "max-width": 45} ] [
      DateTitle.render dispatch state date,
      SlotCell.render Lunch dispatch state date,
      SlotCell.render Evening dispatch state date
    ]

    fieldHasError :: Boolean
    fieldHasError = member NoSlot (unwrap state).errors
    errorMessage :: ReactElement
    errorMessage = if fieldHasError
                   then R.div [RP.className "field"]
                     [R.p [RP.className "help is-danger"] [R.text "Choisissez au moins un créneau"]]
                   else R.p' []


performAction :: T.PerformAction _ State StaticProps DomainEvent
performAction event props state = void $ T.cotransform $ applyEvent props event

spec :: forall e. T.Spec _ State StaticProps DomainEvent
spec = T.simpleSpec performAction render

main :: forall e. Eff _ Unit
main = do
  str <- getInitProps
  case decodeJson =<< jsonParser str of
    Right props -> defaultMain spec initialState props
    Left message -> do
      log ("error: " <> message)
      defaultMain spec initialState (StaticProps {id: "", range: []})
