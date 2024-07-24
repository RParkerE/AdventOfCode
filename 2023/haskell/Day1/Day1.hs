{-# LANGUAGE ImportQualifiedPost #-}

import Data.Char (isDigit)
import Data.List (isPrefixOf)
import Data.Map.Strict qualified as M
import System.IO ()

word2num :: M.Map String String
word2num =
  M.fromList
    [ ("one", "1"),
      ("two", "2"),
      ("three", "3"),
      ("four", "4"),
      ("five", "5"),
      ("six", "6"),
      ("seven", "7"),
      ("eight", "8"),
      ("nine", "9")
    ]

findFirstDigit :: String -> M.Map String String -> Maybe Char
findFirstDigit [] _ = Nothing
findFirstDigit (c : cs) wordMap
  | isDigit c = Just c
  | otherwise = case [num | (word, num) <- M.toList wordMap, word `isPrefixOf` (c : cs)] of
      (n : _) -> Just (head n)
      [] -> findFirstDigit cs wordMap

findLastDigit :: String -> M.Map String String -> Maybe Char
findLastDigit s wordMap = findFirstDigit (reverse s) (M.mapKeys reverse wordMap)

extractCalibrationValue :: String -> M.Map String String -> Int
extractCalibrationValue s wordMap =
  case (findFirstDigit s wordMap, findLastDigit s wordMap) of
    (Just first, Just last) -> read [first, last]
    _ -> 0

processFile :: String -> M.Map String String -> IO Int
processFile [] _ = do
  putStrLn "No filename was provided"
  return 0
processFile filename wordMap = do
  file <- readFile filename
  let fileLines = lines file
  let calibrationValues = map (`extractCalibrationValue` wordMap) fileLines
  return $ sum calibrationValues

main :: IO ()
main = do
  let filePath = "..\\..\\day1_input.txt"
  result <- processFile filePath word2num
  putStrLn $ "The sum of all calibration values is: " ++ show result
