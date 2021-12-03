module Main where

import Iterations

import Control.Exception

main :: IO ()
main = do
  task <- getSomeTask 10000000
  let run = runTask task
  runTask task `onException` printTaskName task
  -- run *> run
