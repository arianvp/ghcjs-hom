module Hom.VDOM 
( patch
, diff
, Node
)
where

import qualified Hom.DOM as DOM
import GHCJS.Types

newtype Node  = Node (JSRef Node)
newtype PatchObject = PatchObject (JSRef PatchObject)

diff :: Node -> Node -> PatchObject
diff = undefined
patch :: PatchObject -> DOM.Node -> IO ()
patch = undefined