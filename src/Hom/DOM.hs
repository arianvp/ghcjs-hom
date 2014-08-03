-- | A minimalistic DOM
module Hom.DOM
( Node
)
where

import GHCJS.Types

newtype Node = Node (JSRef Node)