{-#LANGUAGE TemplateHaskell, OverloadedStrings #-}
import Hom.App
import Hom.DOM
import Hom.VDOM
import Control.Concurrent
import Control.Monad
import Data.Text (pack)

import Control.Lens hiding (Action)


data AppState = AppState { _counter :: Int} deriving (Show)

makeLenses ''AppState

data Action = NoOp
            | Increment
            | Reset deriving (Show)



step :: Action -> AppState -> AppState
step NoOp = id
step Increment = over counter succ
step Reset = const $ AppState 0


render :: AppState -> Node
render state =
  node "div" emptyProps
    [ text . pack . show $ state^.counter]


main = do
  (app,handle) <- runApp NoOp (AppState 0)  step render
  body <- getBody
  body `appendChild` app

  -- two "event emitters"
  forkIO . forever $ do
    handle Increment
    threadDelay $ 1000 * 100

  forkIO . forever $ do
    handle Reset
    threadDelay $ 1000 * 1000