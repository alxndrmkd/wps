module Main where

import WP as W
import Data.List.Split

main :: IO ()
main = do
    putStrLn "Write initial capacities.."
    cs <- getLine
    putStrLn "Write target value"
    t <- getLine
    let caps = map (\c -> read c :: Int) (splitOn " " cs)
        target = read t :: Int

    if target > (maximum caps)
       then putStrLn "Target value must be less than greater capacity"
       else do
           print (W.solve caps target)
           putStrLn "John McClane is proud of me!"

