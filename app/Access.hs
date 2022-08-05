{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Access where

import           Data.Text
import           Data.Aeson.TH
import           Web.JWT
import           LoadToml
import           Data.Aeson
import           Lens.Micro.Platform
import           Data.Map.Strict as M
import           Content (ContentMap)

data Access = Access (Map Text Text)
  deriving Show

grantAccess :: ContentMap -> JWTClaimsSet -> Access
grantAccess files claims = Access $ files `intersection` filteredClaims
  where
    claimMap = unClaimsMap . unregisteredClaims $ claims

    filteredClaims = M.filter
      (\b -> case b of
         Bool True -> True
         _         -> False)
      claimMap

$(deriveJSON defaultOptions ''Access)