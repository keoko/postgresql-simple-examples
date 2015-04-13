-- https://ocharles.org.uk/blog/posts/2012-12-03-postgresql-simple.html
{-# LANGUAGE OverloadedStrings #-}
module Santa where

import Data.Text
import Data.Int(Int64)
import Data.ByteString (ByteString)
import Control.Applicative
import Control.Monad
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow

data Present = Present { presentName :: Text} deriving Show

data Location = Location { locLat :: Double
                         , locLong :: Double
                         } deriving Show

data Child = Child { childName :: Text
                   , childLocation :: Location
                   } deriving Show

uri :: ByteString
uri = "postgres://natxo@localhost/helloworld"

instance FromRow Present where
  fromRow = Present <$> field

instance ToRow Present where
  toRow p = [toField (presentName p)]

instance FromRow Child where
  fromRow = Child <$> field <*> liftM2 Location field field

instance ToRow Child where
  toRow c = [toField (childName c), toField (locLat (childLocation c)), toField (locLong (childLocation c))]


allChildren :: Connection -> IO [Child]
allChildren c = query_ c "SELECT name, loc_lat, loc_long FROM child"

addPresent :: Connection -> Present -> IO Int64
addPresent c present = execute c "INSERT INTO present (name) VALUES (?)" present

allPresents :: Connection -> IO [Present]
allPresents c = query_ c "SELECT name FROM present"


main :: IO ()
main = do
  conn <- connectPostgreSQL uri
  putStrLn "all children:"
  mapM_ (putStrLn . show) =<< allChildren conn
  putStrLn "all presents:"
  mapM_ (putStrLn . show) =<< allPresents conn
  putStrLn "add new present:"
  present <- getLine
  addedPresents <- addPresent conn Present {presentName=(pack present)}
  putStrLn $ "added presents: " ++ show addedPresents
