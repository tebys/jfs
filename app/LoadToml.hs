{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module LoadToml where

import           Toml
import           Lens.Micro.Platform (makeLenses)
import           Data.Text (Text)
import           Data.Map.Strict

data Settings = Settings { _settingsPort :: !Port
                         , _settingsSecret :: !Text
                         , _settingsFiles :: FileMap
                         }

type FileMap = Map Text FilePath

newtype Port = Port Int
  deriving Show

settingsCodec :: TomlCodec Settings
settingsCodec = Settings
  <$> Toml.diwrap (Toml.int "server.port") .= _settingsPort
  <*> Toml.text "server.secret" .= _settingsSecret
  <*> Toml.map (Toml.text "claim") (Toml.string "path") "fileMap"
  .= _settingsFiles

makeLenses ''Settings