import Text.XHtml (object)
infFibs :: Num a => [a]
infFibs = go 0 1 
    where 
        go a b = a : go b (a + b)

fibs :: Num a => Int -> [a]
fibs n = take n infFibs 

fib :: Num a => Int -> a
fib n = infFibs !! n

sieveOfEratosthenes :: Integral a => [a]
sieveOfEratosthenes = sieve [] [2..]
    where 
        sieve prm (x:xs) = 
            if all (\y -> x `mod` y /= 0) prm 
                then x : sieve (prm ++ [x]) xs
                else sieve prm xs
                
sieveOfEratosthenesN :: Integral a => Int -> [a]
sieveOfEratosthenesN n = take n sieveOfEratosthenes 

quicksort :: Ord a => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = 
    let smallerEqual = [a | a <- xs, a <= x]
        larger = [a | a <- xs, a > x]
    in quicksort smallerEqual ++ [x] ++ quicksort larger

quicksortDesc :: Ord a => [a] -> [a]
quicksortDesc [] = []
quicksortDesc (x:xs) = 
    let left     = [a | a <- xs, a > x]
        right    = [a | a <- xs, a <= x]
    in quicksortDesc left ++ [x] ++ quicksortDesc right

---------------------------------------------

isRound :: (Eq a, Floating a, RealFrac a) => a -> Bool
isRound x = x == fromIntegral (truncate x)

sqrtFactory :: (Num a, Enum a, Floating a, RealFrac a) => Int -> [a]
sqrtFactory n = take n $ filter isRound $ map sqrt [1..] 

powFactory :: (Integral a, Show a) => Int -> [a]
powFactory n = take n $ filter (\x -> last (show $ x ^ 5) == '7') [1..] 