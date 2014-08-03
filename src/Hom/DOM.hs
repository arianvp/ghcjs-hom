-- | A minimalistic DOM
module Hom.DOM
( Elem
, newElem
, appendChild
, newTextElem
, getBody
)
where

import GHCJS.Types
import GHCJS.Foreign
import Data.Text

newtype Elem = Elem (JSRef Elem)


foreign import javascript unsafe "document.createElement($1)"
  js_newElem :: JSString -> IO Elem



newElem :: Text -> IO Elem
newElem = js_newElem . toJSString


newTextElem :: Text -> IO Elem
newTextElem = js_newTextElem . toJSString


foreign import javascript unsafe "document.createTextNode($1)"
  js_newTextElem :: JSString -> IO Elem


foreign import javascript unsafe "document.body"
  js_body :: IO Elem

getBody :: IO Elem
getBody = js_body

foreign import javascript unsafe "$1.appendChild($2)"
  js_appendChild :: Elem -> Elem -> IO Elem


appendChild :: Elem -> Elem -> IO Elem
appendChild = js_appendChild
