{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}

module LoadToml where

import           Toml
import           Lens.Micro.Platform (makeLenses)
import           Data.Text (Text)

data Settings = Settings { _settingsPort :: !Port
                         , _settingsSecret :: !Text
                         , _settingsFiles :: ![SFile]
                         }

newtype Port = Port Int
  deriving Show

data SFile = SFile { _claim :: !Text, _path :: !Text }
  deriving Show

settingsCodec :: TomlCodec Settings
settingsCodec = Settings
  <$> Toml.diwrap (Toml.int "server.port") .= _settingsPort
  <*> Toml.text "server.secret" .= _settingsSecret
  <*> Toml.list sfileCodec "file" .= _settingsFiles

sfileCodec :: TomlCodec SFile
sfileCodec =
  SFile <$> Toml.text "claim" .= _claim <*> Toml.text "path" .= _path

makeLenses ''SFile

makeLenses ''Settings