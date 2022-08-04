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

main :: IO ()
main = do
  tomlRes <- Toml.decodeFileEither settingsCodec "jfs.toml"
  case tomlRes of
    Left errs -> print $ Toml.prettyTomlDecodeErrors errs
    Right s   -> do
      state <- newTVarIO s
      let Port port = s ^. settingsPort
      scotty port
        $ do
          middleware logStdoutDev
          get "/another" getAnotherRoute
          get "/:file" $ getContentRoute state

-- print $ settings ^? (settingsFiles . _head . claim)
getContentRoute :: TVar Settings -> ActionM ()
getContentRoute state = do
  auth <- header "Authorization"
  settings <- liftIO $ readTVarIO state
  case getClaims (settings ^. settingsSecret) auth of
    Left _  -> status status401
    Right c -> do
      liftIO $ print c
      html $ settings ^. (settingsFiles . _head . claim . lazy)

getAnotherRoute :: ActionM ()
getAnotherRoute = do
  html "Hola Mundo! 2"