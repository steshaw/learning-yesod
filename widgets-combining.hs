#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package yesod
    --
    -Wall -fwarn-tabs
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

import Yesod

data App = App

mkYesod "App" [parseRoutes|
  / HomeR GET
|]

instance Yesod App where

myWidget1 = do
  toWidget [hamlet|<h1>My Title|]
  toWidget [lucius|h1 { color: green }|]

myWidget2 = do
  setTitle "My Page Title"
  addScriptRemote "http://www.example.com/script.js"

myWidget = do
  myWidget1
  myWidget2

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
  myWidget
{-
  setTitle "toWidgetHead and toWidgetBody"
  toWidgetBody
    [hamlet|<script src="/included-in-body.js">|]
  toWidgetHead
    [hamlet|<script src="/included-in-head.js">|]
-}

main :: IO ()
main = warp 3000 App
