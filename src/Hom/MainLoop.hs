module Hom.MainLoop
( mainLoop
, LoopHandle ()
, update
, target
)
where

import           Hom.DOM       as DOM
import           Hom.VDOM      as VDOM
import           Hom.Animate

import           Data.IORef
import           Data.Maybe
import           Control.Monad
import           Control.Monad.IO.Class

data LoopHandle s = LoopHandle  { update :: s -> IO ()
                                , target :: Elem
                                }

mainLoop :: s -> (s -> VDOM.Node) -> IO (LoopHandle s)
mainLoop initialState render = do
  target             <- createElem $ render initialState
  currentStateRef    <- newIORef Nothing
  redrawScheduledRef <- newIORef False
  currentTreeRef     <- newIORef $ render initialState
  let redraw = do
        writeIORef redrawScheduledRef False
        currentState <- readIORef currentStateRef
        when (isJust currentState) $ do
          currentTree <- readIORef currentTreeRef
          let newTree = render . fromJust $ currentState
          patch target  (diff currentTree newTree)
          writeIORef currentTreeRef newTree
          writeIORef currentStateRef Nothing


  let update newState = do
        currentState <- readIORef currentStateRef
        redrawScheduled <- readIORef redrawScheduledRef
        when (isNothing currentState && not redrawScheduled) $ do
          writeIORef redrawScheduledRef True
          requestAnimationFrame redraw >> return ()
        writeIORef currentStateRef (Just newState)

  liftIO $ return $ LoopHandle update target


