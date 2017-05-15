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

page :: Widget
page =
  [whamlet|
    <p>This is my page. I hope you enjoyed it.
    ^{footer}
  |]

footer :: Widget
footer = do
  toWidget
    [lucius|
      footer {
        font-weight: bold;
        text-align: center
      }
    |]
  toWidget
    [hamlet|
      <footer>
        <p>That's all folks!
    |]

getHomeR :: Handler Html
getHomeR = defaultLayout page

main :: IO ()
main = warp 3000 App
