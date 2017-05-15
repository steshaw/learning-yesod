{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}

module Error where

import Yesod

data Error = Error

mkYesod "Error" [parseRoutes|
  / ErrorR GET
|]

instance Yesod Error

getErrorR :: Handler Html
getErrorR = defaultLayout [whamlet|
  <h1>Error
|]
