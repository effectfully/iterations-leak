{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE LambdaCase #-}

module Iterations where

import Control.Exception
import Control.Monad
import Control.Monad.IO.Class

data Iterations req resp m a
  = Done a
  | Next req (resp -> m (Iterations req resp m a))
  deriving (Functor)

runIterations :: MonadIO m => (req -> m resp) -> Iterations req resp m a -> m a
runIterations f = \case
  Done x     -> return x
  Next req k -> do
    resp <- f req
    runIterations f =<< k resp

data Task m = Task
  { _taskName  :: String
  , _taskIters :: Iterations () Bool m ()
  }

getSomeIterations :: MonadIO m => Int -> m (Iterations () Bool m ())
getSomeIterations 0 = pure $ Done ()
getSomeIterations n = pure . Next () $ \b ->
  if b then getSomeIterations (n - 1) else liftIO $ fail "false"

getSomeTask :: MonadIO m => Int -> m (Task m)
getSomeTask n = Task "Consume memory" <$> getSomeIterations n

runTask :: MonadIO m => Task m -> m ()
runTask = runIterations (\() -> pure True) . _taskIters

printTaskName :: MonadIO m => Task m -> m ()
printTaskName = liftIO . putStrLn . _taskName
-- Pretending this is some big uninlinable function asking for a 'Task' and only
-- using the '_taskName' part of it.
{-# NOINLINE printTaskName #-}
