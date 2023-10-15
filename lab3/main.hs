filter' :: Ord a => a -> [a] -> [a]
filter' _ [] = []
filter' a (x:xs) = flt a [] (x:xs)
    where 
        flt _ res [] = res
        flt a res (x:xs)
            | x < a     = flt a res xs
            | otherwise = flt a (res ++ [x]) xs

data BinaryTree a = EmptyTree | TreeNode a (BinaryTree a) (BinaryTree a) deriving Show

mockBinaryTree :: BinaryTree Int
mockBinaryTree =
    TreeNode 1
        (TreeNode 2
            (TreeNode 3 EmptyTree EmptyTree)
            (TreeNode 4 EmptyTree EmptyTree))
        (TreeNode 5
            (TreeNode 6 EmptyTree EmptyTree)
            (TreeNode 7
                (TreeNode 8 EmptyTree EmptyTree)
                (TreeNode 9
                    (TreeNode 10 EmptyTree EmptyTree)
                    (TreeNode 11
                        (TreeNode 12 EmptyTree EmptyTree)
                        (TreeNode 13
                            EmptyTree
                            (TreeNode 15 EmptyTree EmptyTree))))))

countTreeLeafs :: BinaryTree a -> Int
countTreeLeafs EmptyTree = 0
countTreeLeafs (TreeNode _ EmptyTree EmptyTree) = 1
countTreeLeafs (TreeNode _ left right) = countTreeLeafs left + countTreeLeafs right