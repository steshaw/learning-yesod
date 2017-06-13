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

myLayout :: Widget -> Handler Html
myLayout widget = do
  pc <- widgetToPageContent $ do
    widget
    toWidget [lucius|
      body { font-family: Verdana }
    |]
  withUrlRenderer
    [hamlet|
      $doctype 5
      <html>
        <head>
          <title>#{pageTitle pc}
          <meta charset="utf-8">
          ^{pageHead pc}
        <body>
          <article>
            ^{pageBody pc}
    |]

instance Yesod App where
  defaultLayout = myLayout

getHomeR :: Handler Html
getHomeR = defaultLayout
  [whamlet|
    <p>Hello World!
  |]

main :: IO ()
main = warp 3000 App
