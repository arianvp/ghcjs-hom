{-#LANGUAGE OverloadedStrings, TemplateHaskell #-}

import Hom.Animate
import Hom.MainLoop
import Hom.DOM
import Hom.VDOM
import Control.Monad
import Control.Lens
import Data.Text (pack)

import Control.Concurrent
import Control.Monad.Trans.State
import Control.Monad.IO.Class

data AppState = AppState { _counter :: Int }

initialState = AppState 0 
makeLenses ''AppState

counterComp :: Int -> Node
counterComp i = node "div" emptyProps [ text . pack . show $ i]
render state = 
  node "div" emptyProps
    [ text "test"
    , counterComp $ state^.counter]


app ::  LoopHandle AppState -> StateT AppState IO ()
app handle = forever $ do
  liftIO . threadDelay $ 1000 * 1000
  counter += 1
  state <- get
  liftIO $ update handle state
main = do
  body <- getBody

  handle <- mainLoop initialState render
  body `appendChild`  target handle

  evalStateT (app handle) initialState
  

