import Data.List

data WorkResult = Success | Failure | Suspended | Incomplete | Canceled deriving (Eq, Show)

data TaskType = Design | Development | Testing | Deployment deriving (Eq, Show)

data TaskWork = TaskWork
  { estTime :: Int,
    workedTime :: Int,
    delayedTime :: Int,
    changes :: String,
    workDescription :: String,
    workResult :: WorkResult
  }
  deriving (Show)

data Task = Task
  { name :: String,
    taskDescription :: String,
    taskType :: TaskType,
    works :: [TaskWork]
  }
  deriving (Show)

compareByDelayedTime :: Task -> Task -> Ordering
compareByDelayedTime t1 t2 = compare (delayTime t2) $ delayTime t1

totalWorks :: Task -> Int
totalWorks task = length $ works task

successWorks :: Task -> Int 
successWorks task = length . filter (\x -> workResult x == Success) $ works task

delayedWorks :: Task -> Int 
delayedWorks task = length . filter (\x -> delayedTime x > 0) $ works task

problemWorks :: Task -> Int 
problemWorks task = length . filter (\x -> delayedTime x > 0 || workResult x /= Success) $ works task

totalTime :: Task -> Int 
totalTime task = sum . map workedTime $ works task

estimatedTime :: Task -> Int 
estimatedTime task = sum . map estTime $ works task

delayTime :: Task -> Int 
delayTime task = sum . map delayedTime $ works task

sortMostDelayed :: [Task] -> [Task]
sortMostDelayed = sortBy compareByDelayedTime

taskWorks =
  [ TaskWork 50 30 0 "Changes 1" "Work 1" Success,
    TaskWork 80 90 10 "Changes 2" "Work 2" Failure,
    TaskWork 60 40 0 "Changes 3" "Work 3" Success,
    TaskWork 70 70 0 "Changes 4" "Work 4" Incomplete,
    TaskWork 55 50 5 "Changes 5" "Work 5" Canceled,
    TaskWork 150 200 50 "Changes 6" "Work 6" Suspended
  ]

tasks =
  [ Task "Task 1" "Description 1" Design $ fst worksHalfs,
    Task "Task 2" "Description 2" Development $ snd worksHalfs
  ]
  where
    worksHalfs = splitAt (length taskWorks `div` 2) taskWorks

main :: IO ()
main = do
    putStrLn "Tasks"
    print tasks

    putStrLn "\nTasks Sorted by Delayed Time (Descending):"
    print $ sortMostDelayed tasks

    putStrLn "\nResults for Task 1:"
    printResults (head tasks)

    putStrLn "\nResults for Task 2:"
    printResults (last tasks)

printResults :: Task -> IO ()
printResults task = do
    putStrLn "Total Number of Works:"
    print $ totalWorks task

    putStrLn "Number of Success Works:"
    print $ successWorks task

    putStrLn "Number of Delayed Works:"
    print $ delayedWorks task

    putStrLn "Number of Problematic Works:"
    print $ problemWorks task

    putStrLn "Total Time Spent:"
    print $ totalTime task

    putStrLn "Total Estimated Time:"
    print $ estimatedTime task

    putStrLn "Total Delayed Time:"
    print $ delayTime task

    putStrLn "-----------------------------------"
