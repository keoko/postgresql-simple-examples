{-# LANGUAGE OverloadedStrings #-}
module Todo where

-- get todo item
-- add new item
-- delete item
-- update item
-- auto increment id field
-- uuid for id field
-- null values on title
-- extract IO value
import Data.Text
import Data.ByteString (ByteString)
import Control.Applicative
import Control.Monad.IO.Class (liftIO)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow


data TodoItem = TodoItem { id :: Int
                         , title :: Text
                         , completed :: Bool
                         } deriving Show

instance FromRow TodoItem where
  fromRow = TodoItem <$> field <*> field <*> field

uri :: ByteString
uri = "postgres://natxo@localhost/helloworld"

allTodoItems :: Connection -> IO [TodoItem]
allTodoItems c = query_ c "SELECT id, title, completed FROM todo"


getTodoItem :: Connection -> Int -> IO [TodoItem]
getTodoItem c id = query c "SELECT id, title, completed FROM todo WHERE id = ?" $ Only id 

main :: IO ()
main = do
  conn <- connectPostgreSQL uri
  putStrLn "all todo"
  mapM_ (putStrLn . show) =<< allTodoItems conn
  mapM_ (putStrLn . show) =<< getTodoItem conn 2
