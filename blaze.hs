#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package blaze-html
    --package blaze-markup
    --
    -Wall -fwarn-tabs
-}

-- Blaze examples from the Blaze tutorial.
-- https://jaspervdj.be/blaze/tutorial.html

{-# LANGUAGE OverloadedStrings #-}

import Control.Monad (forM_)
import Text.Blaze.Html5 (Html, (!))
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Pretty
import Text.Blaze.Internal (MarkupM)

numbers :: Int -> Html
numbers n = H.docTypeHtml $
  H.head $ do
    H.title "Natural numbers"
    H.body $ do
      H.p "A list of natural numbers"
      H.ul $ forM_ [1 .. n] (H.li . H.toHtml)

simpleImage :: Html
simpleImage = H.img ! A.src "foo.png"

parentAttributes :: Html
parentAttributes = H.p ! A.class_ "styled" $ H.em "Context here."

altParentAttributes :: Html
altParentAttributes = H.p $ H.em "Context here." ! A.class_ "styled"

data User = User
  { userName :: String
  , userPoints :: Int
  }

userInfo :: Maybe User -> Html
userInfo u = H.div ! A.id "user-info" $ case u of
  Nothing ->
    H.a ! A.href "/login" $ "Please login."
  Just user -> do
    _ <- "Logged in as "
    H.toHtml $ userName user
    _ <- ". Your points: "
    H.toHtml $ userPoints user

somePage :: Maybe User -> Html
somePage u = H.html $ do
  H.head $
    H.title "Some page."
  H.body $ do
    userInfo u
    "The rest of the page."

-- Examples Days of Hackage 
-- See https://ocharles.org.uk/blog/posts/2012-12-22-24-days-of-hackage-blaze.html.

greet :: String -> Html
greet name = H.docTypeHtml $ do
  H.head $
    H.title "Hello!"
  H.body $ do
    H.h1 "Tervetuloa!"
    H.p ("Hello " >> H.toHtml name >> "!")

addHr :: Monoid a => [MarkupM a] -> MarkupM a
addHr [] = mempty
addHr [para] = para
addHr (para:paras) = para >> H.hr >> addHr paras

doc :: Html
doc = H.docTypeHtml $
  H.body $
    addHr [ H.p "Hello, world!"
          , H.p "How are you?"
          ]

main :: IO ()
main = do
  putStrLn "numbers 5"
  putStrLn $ renderHtml (numbers 5)

  putStrLn "somePage Nothing"
  putStrLn $ renderHtml (somePage Nothing)

  putStrLn "somePage (Just (User \"Steven\" 99)"
  putStrLn $ renderHtml (somePage (Just (User "Steven" 99)))

  putStrLn "greet \"Fred\""
  putStrLn $ renderHtml (greet "Fred")

  putStrLn "doc"
  putStrLn $ renderHtml doc
