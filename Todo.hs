{-# LANGUAGE OverloadedStrings #-}
module Todo where

-- auto increment id field
-- uuid for id field
-- null values on title
-- extract IO value
import Data.Text
import Data.Int (Int64)
import Data.ByteString (ByteString)
import Control.Applicative
import Control.Monad.IO.Class (liftIO)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Simple.FromRow
import Database.PostgreSQL.Simple.ToRow


data TodoItem = TodoItem { todoId :: Int
                         , todoTitle :: Text
                         , todoCompleted :: Bool
                         } deriving Show

instance FromRow TodoItem where
  fromRow = TodoItem <$> field <*> field <*> field

instance ToRow TodoItem where
  toRow t = [toField (todoId t), toField (todoTitle t), toField (todoCompleted t)]

uri :: ByteString
uri = "postgres://natxo@localhost/helloworld"

allTodoItems :: Connection -> IO [TodoItem]
allTodoItems c = query_ c "SELECT id, title, completed FROM todo"

getTodoItem :: Connection -> Int -> IO [TodoItem]
getTodoItem c id = query c "SELECT id, title, completed FROM todo WHERE id = ?" $ Only id

addTodoItem :: Connection -> TodoItem -> IO Int64
addTodoItem c i = execute c "INSERT INTO todo (id, title, completed) VALUES (?, ?, ?)" i

removeTodoItem :: Connection -> TodoItem -> IO Int64
removeTodoItem c i = execute c "DELETE FROM todo WHERE id = ?" $ Only $ todoId i

changeTodoItem :: Connection -> TodoItem -> IO Int64
changeTodoItem c i = execute c "UPDATE todo SET title = ?, completed = ? WHERE id = ?" (todoTitle i, todoCompleted i, todoId i)

main :: IO ()
main = do
  conn <- connectPostgreSQL uri
  putStrLn "all todo"
  mapM_ (putStrLn . show) =<< allTodoItems conn
  mapM_ (putStrLn . show) =<< getTodoItem conn 2
  putStrLn . show =<< addTodoItem conn TodoItem {todoId=2, todoTitle="test", todoCompleted=False}
  putStrLn . show =<< changeTodoItem conn TodoItem {todoId=2, todoTitle="test changed", todoCompleted=True}
  putStrLn . show =<< removeTodoItem conn TodoItem {todoId=2, todoTitle="test", todoCompleted=False}

