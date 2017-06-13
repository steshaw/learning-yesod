#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package blaze-builder
    --package http-types
    --package text
    --package yesod
    --
    -Wall -fwarn-tabs
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

import Blaze.ByteString.Builder.Char.Utf8 (fromText)
import Control.Arrow ((***))
import Data.Monoid (mappend)
import Network.HTTP.Types (encodePath)
import Yesod

import qualified Data.Text as T
import qualified Data.Text.Encoding as TE

data Slash = Slash

mkYesod "Slash" [parseRoutes|
  /      RootR GET
  //     RootSlashesR GET
  /foo   FooR GET
  /foo// FooSlashesR GET
|]

instance Yesod Slash where
  approot = ApprootStatic "http://localhost:3000"

  joinPath _ ar pieces' qs' =
    fromText ar `mappend` encodePath pieces qs
    where
      qs = map (TE.encodeUtf8 *** go) qs'
      go "" = Nothing
      go x = Just $ TE.encodeUtf8 x
      pieces = pieces' ++ [""]

  -- We want to keep canonical URLs. Therefore, if the URL is missing a
  -- trailing slash, redirect. But the empty set of pieces always stays the
  -- same.
  cleanPath _ [] = Right []
  cleanPath _ s
    | dropWhile (not . T.null) s == [""] = -- the only empty string is the last one
        Right $ init s
    -- Since joinPath will append the missing trailing slash, we simply
    -- remove empty pieces.
    | otherwise = Left $ filter (not . T.null) s

getRootR :: Handler Html
getRootR = defaultLayout
  [whamlet|
    <p>
      <a href=@{RootR}>RootR
    <p>
      <a href=@{FooR}>FooR
    <p>
      <a href="@{RootR}//">RootR//
    <p>
      <a href="@{FooR}//">FooR//
    <p>
      <a href="@{RootSlashesR}">RootSlashesR @{RootSlashesR}
    <p>
      <a href="@{FooSlashesR}">FooSlashesR @{FooSlashesR}
  |]

neverGetHere :: Widget
neverGetHere = [whamlet|<h1>You should never get here|]

getRootSlashesR :: Handler Html
getRootSlashesR = defaultLayout neverGetHere

getFooR :: Handler Html
getFooR = getRootR

getFooSlashesR :: Handler Html
getFooSlashesR = defaultLayout neverGetHere

main :: IO ()
main = warp 3000 Slash
