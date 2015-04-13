-- source: https://github.com/begriffs/haskell-postgres-examples/blob/master/postgresql-simple/two-and-two.hs
{-# LANGUAGE OverloadedStrings #-}
module Basics where

import Database.PostgreSQL.Simple

connection :: IO (Connection)
connection = connectPostgreSQL "postgresql://natxo@localhost/helloworld"

main :: IO ()
main = do
  conn <- connection
  putStrLn "2 + 2"
  mapM_ print =<< (query_ conn "select 2 + 2" :: IO [Only Int])

  putStrLn "3 + 5"
  mapM_ print =<< ( query conn "select ? + ?" (3 :: Int, 5 :: Int) :: IO [Only Int] )
