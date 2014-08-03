module Hom.MainLoop
(
)
where

import           Hom.DOM       as DOM
import           Hom.VDOM      as VDOM
import           Hom.Animate

import           Data.IORef
import           Data.Maybe
import           Control.Monad
mainLoop :: s -> (s -> VDOM.Node) -> DOM.Node -> IO (s -> IO ())
mainLoop initialState render root = do
  currentStateRef    <- newIORef $ Just initialState
  redrawScheduledRef <- newIORef False
  currentTreeRef     <- newIORef $ render initialState
  let redraw :: IO ()
      redraw = do
        return ()

  return (\x -> return ())
  --let redraw = do
  --      writeIORef redrawScheduledRef False
  --      currentState <- readIORef currentStateRef
  --      when (isJust currentState) $ do
  --        currentTree <- currentTreeRef
  --        let newTree =  diff currentTree $ render currentState
  --        patch root $ newTree
  --        writeIORef currentTreeRef newTree
  --        writeIORef currentStateRef Nothing

  --let update newState = do
  --      currentState    <- readIORef currentStateRef
  --      redrawScheduled <- readIORef redrawScheduledRef
  --      when (isNothing currentState && not redrawScheduled) $ do
  --        writeIORef redrawScheduledRef True
  --        requestAnimationFrame redraw
  --        writeIORef currentStateRef newState
  --return update