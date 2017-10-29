module ThermiteUtils (defaultMain) where

import Prelude

import Control.Monad.Eff (Eff)
import DOM (DOM) as DOM
import DOM.HTML (window) as DOM
import DOM.HTML.Types (htmlDocumentToDocument) as DOM
import DOM.HTML.Window (document) as DOM
import DOM.Node.Types (ElementId(..), documentToNonElementParentNode) as DOM
import DOM.Node.NonElementParentNode (getElementById) as DOM
import Data.Foldable (traverse_)
import React (createFactory)
import ReactDOM (render)
import Thermite (Spec, createClass)

defaultMain
  :: forall state props action eff
  . Spec eff state props action
  -> state
  -> props
  -> Eff (dom :: DOM.DOM | eff) Unit
defaultMain spec initialState props = void do
  let component = createClass spec initialState
  document <- DOM.window >>= DOM.document
  container <- DOM.getElementById (DOM.ElementId "app") (DOM.documentToNonElementParentNode $ DOM.htmlDocumentToDocument document)
  traverse_ (render (createFactory component props)) container
