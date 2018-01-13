module Main where

import Components.ActivityPicker as ActivityPicker
import Components.DateTitle as DateTitle
import Components.SlotCell as SlotCell
import Components.TimeSlotTitle as TimeSlotTitle
import Components.NameInput as NameInput
import Control.Monad.Eff.Console (log)
import Control.Monad.Eff (Eff)
import DOM.HTML (window)
import DOM.HTML.Types (htmlDocumentToNonElementParentNode)
import DOM.HTML.Window (document)
import DOM.Node.Node (textContent)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (ElementId(..), elementToNode)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Parser (jsonParser)
import Data.Date (Date)
import Data.Either (Either(..))
import Data.Maybe (Maybe(Just, Nothing))
import Data.Newtype (unwrap)
import Preferences (DomainEvent(..), applyEvent)
import Prelude (Unit, bind, discard, pure, void, ($), (<$>), (<<<), (<>), (=<<))
import React (ReactElement)
import React.DOM as R
import React.DOM.Props as RP
import Slot (TimeSlot(..))
import State (State, initialState)
import StaticProps (StaticProps(..))
import Thermite as T
import ThermiteUtils (defaultMain)

getInit :: Eff _ String
getInit = do
  win <- window
  doc <- document win
  maybeEl <- getElementById (ElementId "init-props") (htmlDocumentToNonElementParentNode doc)
  case maybeEl of
    Nothing -> pure ""
    Just el -> textContent <<< elementToNode $ el

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

performAction :: T.PerformAction _ State StaticProps DomainEvent
performAction event props state = void $ T.cotransform $ applyEvent props event

spec :: forall e. T.Spec _ State StaticProps DomainEvent
spec = T.simpleSpec performAction render

main :: forall e. Eff _ Unit
main = do
  str <- getInit
  case decodeJson =<< jsonParser str of
    Right props -> defaultMain spec initialState props
    Left message -> do
      log ("error: " <> message)
      defaultMain spec initialState (StaticProps {id: "", range: []})
