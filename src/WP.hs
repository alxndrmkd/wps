module WP where

import Data.Set as S (Set, singleton, union, elems, map, fromList, toList)

data Glass = Glass { capacity :: Int, cont :: Int } deriving (Eq, Ord)
instance Show Glass where
    show (Glass cap con) = concat ["Glass (", show con , "/", show cap, ")"]

data Path = Path { history :: [State], endState :: State } deriving (Eq, Ord)
instance Show Path where
    show (Path h es) = concat ["End state:\n", show es, "\n","Path:\n", show h, "\n"]

data State = State { glasses :: [Glass] } deriving (Eq, Ord)
instance Show State where
    show (State gls) = concat [show gls, "\n"]

fill :: Int -> State -> State
fill n state = update n g state
    where cap= capacity ((glasses state) !! n)
          g  = Glass cap cap

empty :: Int -> State -> State
empty n state = update n g state 
    where cap = capacity ((glasses state) !! n)
          g = Glass cap 0

pour :: Int -> Int -> State -> State
pour from to state = update to g0 (update from g1 state)
    where fromGl = ((glasses state) !! from)
          toGl = ((glasses state) !! to)
          amount = min (cont fromGl) ((capacity toGl) - (cont toGl))
          g0 = Glass (capacity toGl) ((cont toGl) + amount)
          g1 = Glass (capacity fromGl) ((cont fromGl) - amount)

genMoves :: State -> [State -> State]
genMoves state = f ++ e ++ p
    where l = (length (glasses state)) - 1
          f = [fill i | i <- [0..l]]
          e = [empty i | i <- [0..l]]
          p = [pour i j | i <- [0..l], j <- [0..l], i /= j]

extend :: (State -> State) -> Path -> Path
extend move (Path h es) = Path (es:h) (move es)

from :: Set Path -> Set State -> [State -> State] -> [Set Path]
from paths explored moves = paths:(from more (union explored (S.map endState more)) moves)
    where more = fromList [n | p <- toList paths, n <- Prelude.map (\m -> extend m p) moves, not (elem (endState n) explored)]

genPathSets :: [Int] -> [Set Path]
genPathSets caps = from (singleton ip) (singleton is) moves
    where ip = initialPath caps
          is = initialState caps
          moves = genMoves is

findSolutions :: Int -> [Set Path] -> [Path]
findSolutions target pathSets = [p | ps <- pathSets, p <- toList ps, elem target (Prelude.map (\g -> cont g)(glasses (endState p)))]

solve :: [Int] -> Int -> Path
solve caps target = head (findSolutions target pathSets)
    where pathSets = genPathSets caps

initialState :: [Int] -> State
initialState caps = State gls
    where gls = Prelude.map (\x -> Glass x 0) caps

initialPath :: [Int] -> Path
initialPath caps = Path [] (initialState caps)

update :: Int -> Glass -> State -> State
update pos value state = State gls
    where gls = updateHelper pos value (glasses state)

updateHelper :: Int -> Glass -> [Glass] -> [Glass]
updateHelper _ _ [] = []
updateHelper pos val (x:xs)
    |pos == 0   = val:xs
    |otherwise  = x:updateHelper (pos - 1) val xs
