#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.5
    --package yesod-core
    --package yesod-static
    --
    -Wall -fwarn-tabs
-}

-- From https://github.com/yesodweb/yesod/blob/master/yesod-static/sample-embed.hs

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

-- |
-- This embeds just a single file; it embeds the source code file
-- \"static-embed.hs\" from the current directory so when you compile,
-- the static-embed.hs file must be in the current directory.
--
-- Try toggling the development argument to 'mkEmbeddedStatic'. When the
-- development argument is true the file \"static-embed.hs\" is reloaded
-- from disk on every request (try changing it after you start the server).
-- When development is false, the contents are embedded and the static-embed.hs
-- file does not even need to be present during runtime.
--
module Main where

import Yesod.Core
import Yesod.EmbeddedStatic

mkEmbeddedStatic False "eStatic" [embedFile "static-embed.hs"]

-- The above will generate variables
-- eStatic :: EmbeddedStatic
-- static_embed_hs :: Route EmbeddedStatic

newtype MyApp = MyApp { getStatic :: EmbeddedStatic }

mkYesod "MyApp" [parseRoutes|
  /       HomeR GET
  /static StaticR EmbeddedStatic getStatic
|]

instance Yesod MyApp where
  addStaticContent = embedStaticContent getStatic StaticR Right

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
  toWidget [julius|console.log("Hello World");|]
  [whamlet|

<h1>Hello
<p>Check out the <a href=@{StaticR static_embed_hs}>embedded file</a>.

|]

main :: IO ()
main = warp 3000 $ MyApp eStatic
