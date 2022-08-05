{-# LANGUAGE OverloadedStrings #-}

module Content where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import           LoadToml (FileMap)
import qualified Data.Map.Strict as M
import           Data.Aeson.Parser
import           Data.Attoparsec.ByteString
import           Data.Text.Encoding (encodeUtf8)
import           Data.Aeson.Types (Value)

type ContentMap = M.Map T.Text Value

makeContent :: FileMap -> IO ContentMap
makeContent = mapM load
  where
    unEscape = eitherResult . parse json . encodeUtf8

    load n = do
      n' <- TIO.readFile n
      case unEscape n' of
        Right r -> return r
        Left s  -> do
          print $ "There is an error in your " ++ n ++ " JSON file"
          print s
          return ""