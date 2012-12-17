import System.Directory
import System.FilePath
import Control.Monad

slash :: FilePath
slash = [pathSeparator]

dirRoot :: FilePath
dirRoot = "sorted" ++ slash

ext :: FilePath -> FilePath
ext f = let ext = takeExtension f
           in if ext == ""
              then "noextension"
              else tail ext

subdir :: FilePath -> FilePath
subdir f = dirRoot ++ (ext f) ++ slash

copyPair :: FilePath -> (FilePath, FilePath)
copyPair f = (f, subdir f ++ f)

main = do
  contents <- getDirectoryContents "."
  unhidden <- return $ filter (\ f -> head f /= '.') contents
  files <- filterM doesFileExist unhidden
  mapM_ (createDirectoryIfMissing True) (map subdir files)
  mapM_ (\ p -> renameFile (fst p) (snd p)) (map copyPair files)
