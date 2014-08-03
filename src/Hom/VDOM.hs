module Hom.VDOM 
( patch
, diff
, Node
, emptyProps
, node, text
, createElem
)
where
import Hom.DOM
import GHCJS.Types
import GHCJS.Foreign
import System.IO.Unsafe
import Data.Text

newtype Props = Props (JSRef Props)
newtype Node  = Node (JSRef Node)
newtype PatchObject = PatchObject (JSRef PatchObject)


foreign import javascript unsafe "[]"
  emptyProps :: Props

foreign import javascript unsafe "node"
  js_node :: JSString -> Props -> JSArray Node -> Node


node :: Text -> Props -> [Node] -> Node
node t p c = js_node (toJSString t) p (unsafePerformIO $ toArray $ Prelude.map (\(Node x) -> x) c) 

foreign import javascript unsafe "text"
  js_text :: JSString -> Node

text :: Text -> Node
text = js_text . toJSString

foreign import javascript unsafe "diff"
  diff :: Node -> Node -> PatchObject

foreign import javascript unsafe "patch"
  patch :: Elem -> PatchObject -> IO ()
diff :: Node -> Node -> PatchObject


foreign import javascript unsafe "createElement"
  createElem :: Node -> IO Elem