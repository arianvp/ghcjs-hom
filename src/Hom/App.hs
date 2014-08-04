{-#LANGUAGE ScopedTypeVariables #-}
module Hom.App
( runApp
, runApp'
)
where

import Hom.DOM
import Hom.VDOM
import Hom.MainLoop
import Control.Monad
import Control.Concurrent
import Control.Monad.Trans.State
import Control.Monad.IO.Class

transfer :: (a -> s -> s) ->  s -> IO a -> IO s
transfer f i =  fmap $ flip f i


transfer' :: (a -> s -> s) -> IO a -> s -> IO s
transfer' f s i  = transfer f i s

external :: a -> IO (IO a, a -> IO ())
external action = do
  ref <- newMVar action
  return (takeMVar ref, putMVar ref)



runApp :: (Show s, Show a)=> a
       -> s
       -> (a -> s -> s)
       -> (s -> Node)
       -> IO (Elem, a -> IO ())

runApp  initialAction initialState step render = do
  loopHandle <- mainLoop initialState render
  let theTarget = target loopHandle
  let updateState = update loopHandle
  (signal, handle) <- external initialAction
  let loop = forever $ do
        state <- get
        newState <- liftIO $ transfer' step signal state
        put newState
        liftIO $ updateState newState
  forkIO $ evalStateT loop initialState 
  return $ (target loopHandle, handle)


runApp' :: (Show s, Show a)=> a -> s -> (a -> State s b) -> (s -> Node) -> IO (Elem, a -> IO ())
runApp' ia is ss = runApp ia is (toStepper ss)



toStepper :: (a -> State s b) -> a -> s -> s
toStepper f a = execState (f a)