#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package blaze-html
    --
    -Wall -fwarn-tabs
-}

-- Blaze examples from the Blaze tutorial.
-- https://jaspervdj.be/blaze/tutorial.html

{-# LANGUAGE OverloadedStrings #-}

import Control.Monad (forM_)
import Text.Blaze.Html5 as H hiding (main)
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Pretty

numbers :: Int -> H.Html
numbers n = H.docTypeHtml $
  H.head $ do
    H.title "Natural numbers"
    body $ do
      p "A list of natural numbers"
      ul $ forM_ [1 .. n] (li . toHtml)

simpleImage :: Html
simpleImage = img ! src "foo.png"

parentAttributes :: Html
parentAttributes = p ! class_ "styled" $ em "Context here."

altParentAttributes :: Html
altParentAttributes = (p $ em "Context here.") ! class_ "styled"

data User = User
  { userName :: String
  , userPoints :: Int
  }

userInfo :: Maybe User -> Html
userInfo u = H.div ! A.id "user-info" $ case u of
  Nothing ->
    a ! href "/login" $ "Please login."
  Just user -> do
    _ <- "Logged in as "
    toHtml $ userName user
    _ <- ". Your points: "
    toHtml $ userPoints user

somePage :: Maybe User -> Html
somePage u = html $ do
  H.head $ do
    H.title "Some page."
  body $ do
    userInfo u
    "The rest of the page."

main :: IO ()
main = do
  putStrLn "numbers 5"
  putStrLn $ renderHtml (numbers 5)
  putStrLn "somePage Nothing"
  putStrLn $ renderHtml (somePage Nothing)
  putStrLn "somePage (Just (User \"Steven\" 99)"
  putStrLn $ renderHtml (somePage (Just (User "Steven" 99)))
