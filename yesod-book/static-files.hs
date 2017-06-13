#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.5
    --package yesod-core
    --package yesod-static
    --package warp
    --
    -Wall -fwarn-tabs
-}

-- From https://github.com/yesodweb/yesod/blob/master/yesod-static/sample.hs

{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

import Yesod.Core
import Yesod.Static
import Network.Wai.Handler.Warp (run)

staticFiles "."

data Sample = Sample { getStatic :: Static }

--getStatic _ = Static $ defaultFileServerSettings { ssFolder = fileSystemLookup $ toFilePath "." }
mkYesod "Sample" [parseRoutes|
  /       RootR GET
  /static StaticR Static getStatic
|]

instance Yesod Sample where

getRootR :: Handler ()
getRootR = do
--  redirect "static"
  redirect (StaticR static_files_hs)
  return ()

main :: IO ()
main = do
  s <- static "."
  toWaiApp (Sample s) >>= run 3000
