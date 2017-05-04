#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.5
    --package yesod
    --
    -Wall -fwarn-tabs
-}

{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
import Yesod

data HelloWorld = HelloWorld

mkYesod "HelloWorld" [parseRoutes|
  / HomeR GET
|]

instance Yesod HelloWorld

getHomeR :: Handler Html
getHomeR = defaultLayout [whamlet|
  <h1>Hello World!
|]

main :: IO ()
main = warp 3000 HelloWorld
