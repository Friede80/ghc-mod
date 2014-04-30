module Boot where

import Control.Applicative ((<$>))
import CoreMonad (liftIO)
import GHC (Ghc)
import Language.Haskell.GhcMod
import Language.Haskell.GhcMod.Ghc
import Language.Haskell.GhcMod.Internal

bootInfo :: Options -> Cradle -> IO String
bootInfo opt cradle = withGHC' $ do
    initializeFlagsWithCradle opt cradle
    boot opt

boot :: Options -> Ghc String
boot opt = do
    mods  <- modules opt
    langs <- liftIO $ listLanguages opt
    flags <- liftIO $ listFlags opt
    pre   <- concat <$> mapM (browse opt) preBrowsedModules
    return $ mods ++ langs ++ flags ++ pre

preBrowsedModules :: [String]
preBrowsedModules = [
    "Prelude"
  , "Control.Applicative"
  , "Control.Exception"
  , "Control.Monad"
  , "Data.Char"
  , "Data.List"
  , "Data.Maybe"
  , "System.IO"
  ]
