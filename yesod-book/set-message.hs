#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package time
    --package yesod
    --
    -Wall -fwarn-tabs
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

import Yesod
import Data.Time (getCurrentTime)

data App = App

mkYesod "App" [parseRoutes|
  / HomeR GET
|]

instance Yesod App where
  defaultLayout contents = do
    PageContent title headTags bodyTags <- widgetToPageContent contents
    mmsg <- getMessage
    withUrlRenderer [hamlet|
      $doctype 5

      <html>
        <head>
          <title>#{title}
          ^{headTags}
        <body>
          $maybe msg <- mmsg
            <div #message>#{msg}
          $nothing
            No message
          ^{bodyTags}
    |]

getHomeR :: Handler Html
getHomeR = do
  html <- defaultLayout [whamlet|<p>Try refreshing|]
  now <- liftIO getCurrentTime
  setMessage [shamlet|You previously visited at: #{show now}|]
  return html

main :: IO ()
main = warp 3000 App
