#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package aeson
    --package yesod
    --
    -Wall -fwarn-tabs
-}

{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE TypeFamilies         #-}

import Data.Aeson
import Yesod

data App = App

mkYesod "App" [parseRoutes|
  / HomeR GET
|]

instance Yesod App

getHomeR :: Handler Value
getHomeR  = return $ object ["msg" .= String "Hello World"]

main :: IO ()
main = warp 3000 App
