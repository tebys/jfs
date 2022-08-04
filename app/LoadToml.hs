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

type FileMap = Map Text Text

newtype Port = Port Int
  deriving Show

data SFile = SFile { _claim :: !Text, _path :: !Text }
  deriving Show

settingsCodec :: TomlCodec Settings
settingsCodec = Settings
  <$> Toml.diwrap (Toml.int "server.port") .= _settingsPort
  <*> Toml.text "server.secret" .= _settingsSecret
  <*> Toml.map (Toml.text "claim") (Toml.text "path") "fileMap"
  .= _settingsFiles

  -- <*> Toml.list sfileCodec "file" .= _settingsFiles
sfileCodec :: TomlCodec SFile
sfileCodec =
  SFile <$> Toml.text "claim" .= _claim <*> Toml.text "path" .= _path

makeLenses ''SFile

makeLenses ''Settings