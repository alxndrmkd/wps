{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_wp (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/dsfn/.cabal/bin"
libdir     = "/home/dsfn/.cabal/lib/x86_64-linux-ghc-8.0.1/wp-0.1.0.0"
datadir    = "/home/dsfn/.cabal/share/x86_64-linux-ghc-8.0.1/wp-0.1.0.0"
libexecdir = "/home/dsfn/.cabal/libexec"
sysconfdir = "/home/dsfn/.cabal/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "wp_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "wp_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "wp_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "wp_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "wp_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
