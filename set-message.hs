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
  now <- liftIO getCurrentTime
  setMessage $ toHtml $ "You previously visited at: " ++ show now
  defaultLayout [whamlet|<p>Try refreshing|]

main :: IO ()
main = warp 3000 App
