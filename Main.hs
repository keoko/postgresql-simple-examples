{-# LANGUAGE OverloadedStrings #-}
module Main where

import Database.PostgreSQL.Simple
import qualified Clients as C
import qualified Words as W

connection :: IO (Connection)
connection = connectPostgreSQL "postgresql://natxo@localhost/helloworld"

mainSimple :: IO ()
mainSimple = do
  conn <- connection
  putStrLn "2 + 2"
  mapM_ print =<< (query_ conn "select 2 + 2" :: IO [Only Int])

main :: IO ()
main = mainSimple
