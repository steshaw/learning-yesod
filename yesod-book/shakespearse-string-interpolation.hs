#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package shakespeare
    --package text
    --
    -Wall -fwarn-tabs
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

import Text.Shakespeare.Text
import qualified Data.Text.Lazy.IO as TLIO
import Data.Text (Text)
import Control.Monad (forM_)

data Item = Item
  { itemName :: Text
  , itemQty :: Int
  }

items :: [Item]
items =
  [ Item "apples" 5
  , Item "bananas" 10
  ]

main :: IO ()
main =
  forM_ items $ \item -> TLIO.putStrLn
    [lt|You have #{show $ itemQty item} #{itemName item}.|]
