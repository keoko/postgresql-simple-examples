{-# LANGUAGE OverloadedStrings #-}
module Main where

import System.Environment (getArgs)
import qualified Clients
import qualified Words
import qualified Santa
import qualified Basics

main :: IO ()
main = getArgs >>= parse

parse ["clients"] = Clients.main
parse ["c"] = Clients.main
parse ["words"] = Words.main
parse ["w"] = Words.main
parse ["santa"] = Santa.main
parse ["s"] = Santa.main
parse ["basics"] = Basics.main
parse _ = putStrLn "usage: result/bin/postgresql-simple-examples [c|w|b|s|clients|words|basics|santa]"
