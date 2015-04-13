{-# LANGUAGE OverloadedStrings #-}
module Words where

import Database.PostgreSQL.Simple

connectionByInfo :: IO (Connection)
connectionByInfo = connect defaultConnectInfo {
  connectDatabase = "helloworld"
  , connectUser = "natxo"
  }

main :: IO ()
main = do
  conn <- connectionByInfo
  putStrLn "enter a word to add"
  wordToAdd <- getLine
  execute conn "insert into words (word) values (?)" $ Only wordToAdd
  putStrLn "enter a word to remove"
  wordToRemove <- getLine
  execute conn "delete from words where word = ?" $ [wordToRemove :: String]
  putStrLn "words list:"
  mapM_ (putStrLn . show . fromOnly) =<< (query_ conn "select word from words" :: IO [Only String])
