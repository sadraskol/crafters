module Components.NameInput where

import Data.Maybe (fromMaybe)
import Data.Newtype (unwrap)
import Preferences (DomainEvent(..))
import Prelude (($))
import React (Event, ReactElement)
import Thermite (EventHandler)
import React.DOM as R
import React.DOM.Props as RP
import State (State)
import Unsafe.Coerce (unsafeCoerce)

render :: _ -> State -> ReactElement
render dispatch state = R.p' [ R.label [] [
    R.span' [R.text "Ton nom: "],
    R.input [ RP.value $ fromMaybe "" (unwrap state).name
            , RP.onChange $ dispatchName dispatch] []
  ]]

dispatchName :: (DomainEvent -> EventHandler) -> Event -> EventHandler
dispatchName dispatch e = dispatch $ Name (unsafeCoerce e).target.value
