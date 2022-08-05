{-# LANGUAGE OverloadedStrings #-}

module Main where

import           LoadToml
import qualified Toml
import           Lens.Micro.Platform
import           GHC.Conc (newTVarIO, TVar, readTVarIO)
import           Web.Scotty
import           Control.Monad.IO.Class (MonadIO(liftIO))
import           Network.HTTP.Types.Status
import           Network.Wai.Middleware.RequestLogger
import           Auth (getClaims)
import           Access
import           Content (makeContent, ContentMap)

main :: IO ()
main = do
  tomlRes <- Toml.decodeFileEither settingsCodec "jfs.toml"
  case tomlRes of
    Left errs -> print $ Toml.prettyTomlDecodeErrors errs
    Right s   -> do
      c <- makeContent $ s ^. settingsFiles
      print c
      state <- newTVarIO s
      content <- newTVarIO c
      let Port port = s ^. settingsPort
      scotty port
        $ do
          middleware logStdoutDev
          get "/another" getAnotherRoute
          get "/:file" $ getContentRoute state content

-- print $ settings ^? (settingsFiles . _head . claim . lazy)
getContentRoute :: TVar Settings -> TVar ContentMap -> ActionM ()
getContentRoute state content = do
  auth <- header "Authorization"
  settings <- liftIO $ readTVarIO state
  case getClaims (settings ^. settingsSecret) auth of
    Left _  -> status status401
    Right c -> do
      cc <- liftIO $ readTVarIO content
      json $ grantAccess cc c

getAnotherRoute :: ActionM ()
getAnotherRoute = do
  html "Hola Mundo! 2"