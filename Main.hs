{-# LANGUAGE OverloadedStrings #-}

import Database.PostgreSQL.Simple

myconn :: ConnectInfo
myconn = defaultConnectInfo {
             connectUser = "natxo",
             connectPassword = "natxo",
             connectDatabase = "helloworld"}

main :: IO ()
main = do
   c <- connect myconn :: IO Connection
   rs <- query_ c "select 2 + 4" :: IO [Only Int]
   putStrLn $ "Result from database " ++ show (fromOnly $ head rs)
