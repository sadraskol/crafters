module Main where

import Components.ActivityPicker as ActivityPicker
import Components.SlotPicker as SlotPicker
import Control.Monad.Aff (launchAff_)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (log)
import Control.Monad.Eff.Now (now)
import DOM.HTML (window)
import DOM.HTML.Location (assign)
import DOM.HTML.Window (location)
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson, (:=), (~>))
import Data.Argonaut.Parser (jsonParser)
import Data.Either (Either(..))
import Data.Newtype (unwrap)
import Network.HTTP.Affjax (post_)
import Network.HTTP.StatusCode (StatusCode(..))
import Preferences (DomainEvent(..), applyEvent)
import Prelude (Unit, bind, discard, void, ($), (<>), (=<<))
import React.DOM as R
import React.DOM.Props as RP
import State (State, initialState)
import StaticProps (StaticProps(..), getInitProps)
import Thermite as T
import ThermiteUtils (defaultMain)

render :: T.Render State StaticProps (DomainEvent _)
render dispatch props state _ =
  [ R.p [RP.className "content"]
    [ R.text "Choisissez les créneaux où vous êtes disponible et les activités auxquelles vous voulez participer. Nous nous occuperons de trouver le meilleur créneau possible."
    , R.br' []
    , R.text "Ce sondage ne vous engage pas à participer aux sessions."
    ]
  , SlotPicker.render dispatch props state
  , ActivityPicker.render dispatch state
  , R.div [RP.className "is-not-expanded"] [
      R.div [RP.className "field"] [
        R.p [RP.className "control"] [
          R.button [
            RP.onClick \_ -> do
              nowInstant <- now
              dispatch (Submit nowInstant requestThenRedirect),
            RP.className "button is-primary"] [R.text "Soumettre mes préférences"]
        ]
      ]
    ]
  ]

requestThenRedirect :: forall eff. StaticProps -> State -> Eff _ Unit
requestThenRedirect props state = launchAff_ do
  response <- post_ ("/api/preferences/" <> monthId) (addCsrf (encodeJson state) (unwrap props).csrf_token)
  case response of
    {status: StatusCode 200} -> do
      liftEff $ redirect ("/months/" <> monthId)
    _ -> do
      liftEff $ log "failure"

  where
    monthId :: String
    monthId = (unwrap props).id

addCsrf :: Json -> String -> Json
addCsrf json token = "_csrf_token" := token ~> json

redirect :: String -> Eff _ Unit
redirect url = (assign $ url) =<< (location =<< window)

performAction :: T.PerformAction _ State StaticProps (DomainEvent _)
performAction event props state = void $ T.cotransform $ applyEvent props event

spec :: forall e. T.Spec _ State StaticProps (DomainEvent _)
spec = T.simpleSpec performAction render

main :: forall e. Eff _ Unit
main = do
  str <- getInitProps
  case decodeJson =<< jsonParser str of
    Right props -> defaultMain spec initialState props
    Left message -> do
      log ("error: " <> message)
      -- TODO display an error message instead
      defaultMain spec initialState (StaticProps {id: "", range: [], csrf_token: ""})
