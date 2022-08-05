module Content where

import           Data.Text
import qualified Data.Text.IO as TIO
import           Lens.Micro.Platform (makeLenses)
import           LoadToml (FileMap)
import qualified Data.Map.Strict as M

type ContentMap = M.Map Text Text

makeContent :: FileMap -> IO ContentMap
makeContent = mapM load
  where
    load n = TIO.readFile n
