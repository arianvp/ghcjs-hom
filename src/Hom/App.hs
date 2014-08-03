{-#LANGUAGE ScopedTypeVariables #-}
module Hom.App
( runApp
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



runApp :: forall s a. a
       -> s
       -> (a -> s -> s)
       -> (s -> Node)
       -> IO (Elem)

runApp  initialAction initialState step render = do
  loopHandle <- mainLoop initialState render
  let theTarget = target loopHandle
  let updateState = update loopHandle
  (signal, handle) <- external initialAction
  let loop = forever $ (liftIO . updateState <=<  liftIO . transfer' step signal) =<< get
  forkIO $ evalStateT loop initialState 
  return $ target loopHandle




