{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Auth where

-- import           Data.Text.Lazy
import           Data.Attoparsec.Text.Lazy
import           Control.Applicative
import           Data.Text.Lazy
import           Web.JWT
import qualified Data.Text as T

--TODO: Do I need to check the expiration date??
{-|
>>getClaims (Just "a") 

>>>getClaims "c3ab8ff13720e8ad9047dd39466b3c8974e592c2fa383d4a3960714caef0c4f2" (Just "BEARER eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MzM2OTM5LCJlbWFpbCI6ImVzdGViYW4rMUBvbmV5ZWFybm9iZWVyLmNvbSIsImlhdCI6MTY1OTYyMzEyOSwiZXhwIjoxNjU5NjI0NjI5LCJjaGFsbGVuZ2VfMzY1Ijp0cnVlLCJjaGFsbGVuZ2VfOTAiOmZhbHNlLCJjaGFsbGVuZ2VfMjgiOmZhbHNlfQ.J315Ie_RpkSlcfh1pwAHB_NcFPNxoS85pBRHWgdVwr4") 
NOW Right (JWTClaimsSet {iss = Nothing, sub = Nothing, aud = Nothing, exp = Just (NumericDate 1659624629), nbf = Nothing, iat = Just (NumericDate 1659623129), jti = Nothing, unregisteredClaims = ClaimsMap {unClaimsMap = fromList [("challenge_28",Bool False),("challenge_365",Bool True),("challenge_90",Bool False),("email",String "esteban+1@oneyearnobeer.com"),("id",Number 336939.0)]}})

>>getClaims Nothing
-}
getClaims :: T.Text -> Maybe Text -> Either String JWTClaimsSet
getClaims secret auth = case auth of
  Nothing  -> Left "Missing Authorization Header"
  Just jwt -> do
    case parse parseToken jwt of
      Fail _ _ err -> Left err
      Done _ token -> do
        case decodeAndVerifySignature
          (toVerify . hmacSecret $ secret)
          (toStrict token) of
          Nothing  -> Left "Could not decode jwt"
          Just jwt -> Right $ claims jwt

parseToken :: Parser Text
parseToken = asciiCI "BEARER" *> skipSpace *> takeLazyText
