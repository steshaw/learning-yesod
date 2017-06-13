#!/usr/bin/env stack
{-
  stack script
    --resolver lts-8.8
    --package yesod
    --
    -Wall -fwarn-tabs
-}

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

import Yesod
import Data.Monoid ((<>))

data App = App

mkYesod "App" [parseRoutes|
  / HomeR GET
|]

instance Yesod App where

loremIpsum :: WidgetT App IO ()
loremIpsum = toWidget [hamlet|
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam semper nibh nec elit ornare semper. Duis sagittis velit ac auctor elementum. Nam aliquam viverra ex, eget consequat sapien aliquam eget. Duis a arcu malesuada, rutrum ante quis, rhoncus mauris. Vestibulum finibus eget eros in mattis. Maecenas malesuada magna ac ipsum iaculis pretium. Sed nibh urna, varius id fermentum in, blandit id enim. Nullam finibus neque sapien, at dictum est viverra vel. Aenean vitae sollicitudin arcu. Maecenas leo odio, ullamcorper eu tristique vitae, lacinia a turpis.

    <p>Quisque ac mi purus. Pellentesque nec lorem interdum lectus porta hendrerit a non lectus. Aenean ex quam, consectetur eu convallis sit amet, rutrum in lorem. Donec consequat lorem arcu, vel facilisis urna convallis ac. Maecenas molestie, arcu vitae pharetra euismod, mi metus tincidunt nisl, vitae tempor turpis felis fermentum eros. Sed mattis sem ac quam iaculis imperdiet. Praesent commodo ac enim ac varius. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam molestie tortor est, eleifend pulvinar enim hendrerit in.
  |]

heading :: Widget
heading = do
  toWidget [hamlet|<h1 .title>Heading|]
  toWidget [lucius|
    h1 {
      color: green;
      cursor: pointer;
    }
    .red { color: red }
  |]
  -- This JavaScript is automatically inserted as the last child of the body.
  toWidget [julius|
    //
    // With help from http://youmightnotneedjquery.com/.
    //
    function ready(fn) {
      if (document.readyState != 'loading'){
        console.log('executing immediately');
        fn();
      } else {
        console.log('Will execute on DOMContentLoaded');
        document.addEventListener('DOMContentLoaded', fn);
      }
    };
    function addClass(el, className) {
      if (el.classList) {
        console.log('We have a .classList');
        el.classList.add(className);
      } else {
        console.log('Fallback to appening on className');
        el.className += ' ' + className;
      }
    };
    ready(function() {
      var elements = document.querySelectorAll(".title");
      Array.prototype.forEach.call(elements, function(el) {
        el.addEventListener("click", function() {
          addClass(el, "red");
        });
      });
    });
  |]
  loremIpsum

myWidget2 :: Widget
myWidget2 = do
  setTitle "My Page Title"
  -- This JavaScript is automatically inserted as the penultimate child of the body.
  addScriptRemote "http://www.example.com/script.js"

myWidget :: Widget
myWidget = heading <> myWidget2 <> heading

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
  setTitle "toWidgetHead and toWidgetBody"
  toWidgetBody
    [hamlet|<script src="/included-in-body.js">|]
  toWidgetHead
    [hamlet|<script src="/included-in-head.js">|]
  myWidget -- The title in here "wins" as it's set last.

main :: IO ()
main = warp 3000 App
