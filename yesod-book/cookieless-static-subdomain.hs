#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package blaze-builder
    --package bytestring
    --package wai
    --package wai-extra
    --package wai-app-static
    --package warp
    --package yesod
    --package yesod-static
    --
    -Wall -fwarn-tabs
-}

--
-- Originally cribbed from https://github.com/yesodweb/yesod-cookbook/blob/master/cookbook/Pure-Haskell-static-subdomains.md
--

{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}

import Error (Error(..))

import Data.Monoid ((<>))
import Debug.Trace
import Yesod
import Yesod.Static
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.Vhost (vhost)
import Network.Wai.Application.Static -- (staticApp)
import Network.Wai

import qualified Data.ByteString.Char8 as BSC
import qualified Blaze.ByteString.Builder as BSB

staticFiles "static"

-- Standard setup for a project using a static subsite
data App = App
  { getStatic :: Static
  }

mkYesod "App" [parseRoutes|
  /       RootR GET
  /static StaticR Static getStatic
|]


instance Yesod App where
  -- Approot contains the main domain name
  approot = ApprootStatic "http://lvh.me:3000"

  -- Set up urlRenderOverride to point to the static domain name
  urlRenderOverride a (StaticR s) =
    let renderedRoute = renderRoute s
        rr = trace ("renderedRoute = " <> show renderedRoute) renderedRoute
        overridden = uncurry (joinPath a "http://static.lvh.me:3000") $ rr
        builderToString builder = BSC.unpack $ BSB.toByteString builder
    in trace ("overridden = " <> builderToString overridden) $ Just overridden
  urlRenderOverride _ _ = Nothing

getRootR :: Handler Html
getRootR = defaultLayout [whamlet|$newline never
  <img src=@{StaticR steshaw_hat_jpeg}>
|]

main :: IO ()
main = do
  -- Get the static subsite, as well as the settings it is based on
  s@(Static settings) <- static "static"

  -- Generate the main application
  app <- toWaiApp $ App s

  -- Generate the Error application
  errorApp <- toWaiApp $ Error

  -- Serve a virtual host with Warp, using the static application for the
  -- static domain name
  run 3000 $ vhost
    [ ((== (Just "static.lvh.me:3000")) . serverName, staticApp settings)
    , ((== (Just "lvh.me:3000")) . serverName, app)
    ]
    errorApp
    where
      serverName request =
        let host = requestHeaderHost request
        in trace ("requestHeaderHost = " <> show host) host
