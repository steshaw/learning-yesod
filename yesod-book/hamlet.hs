#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package blaze-html
    --package shakespeare
    --
    -Wall -fwarn-tabs
-}

-- Just ignore the quasiquote stuff for now, and that shamlet thing.
-- It will be explained later.

{-# LANGUAGE QuasiQuotes #-}

import Text.Hamlet (shamlet)
import Text.Blaze.Html.Renderer.String (renderHtml)
import Data.Char (toLower)
import Data.List (sort)

data Person = Person
  { name :: String
  , age  :: Int
  }

main :: IO ()
main = putStrLn $ renderHtml [shamlet|
  <p>Hello, my name is #{name person} and I am #{age person}.
  <p>
    Let's do some funny stuff with my name: #
    <b>#{sort $ map toLower (name person)}
  <p>Oh, and in 5 years I'll be #{((+) 5 (age person))} years old.
  <p>A number is #{four}.
|]
  where
    person = Person "Michael" 26
    four = 4 :: Int
