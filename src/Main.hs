module Main where

import Iterations

import Control.Exception

main :: IO ()
main = do
  task <- getSomeTask 10000000
  runTask task `onException` printTaskName task
