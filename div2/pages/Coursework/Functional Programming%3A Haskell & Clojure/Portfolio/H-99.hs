-- 1
myLast :: [a] -> a
myLast [] = error "No elements in list."
myLast [x] = x
myLast (_:xs) = myLast xs

--2
myButLast :: [a] -> a
myButLast [] = error "No elements in list!"
myButLast [x] = error "Only one item in list!"
myButLast (x:_:[]) = x
myButLast (_:xs) = myButLast xs

--3
elementAt :: [a] -> Int -> a
elementAt (x:_) 0 = x
elementAt (_:xs) y = elementAt xs (y-1)

--8
compress :: Eq a => [a] -> [a]
compress all@(x:[]) = all
compress (x:y:xs) = if x == y
						then compress (x:xs)
						else x:(compress (y:xs))
--9
pack' [] c = []
pack' (x:[]) c = replicate c x:[]
pack' (x:y:xs) c = if x == y
					then pack' (x:xs) (c+1)
					else (replicate c x):(pack' (y:xs) 1)

pack xs = pack'  xs 1

--10
encode'' :: [a] -> (Int, a)
encode'' all@(x:_) = (length all, x)

encode' :: [[a]] -> [(Int, a)]
encode' ([xs]) = [encode'' xs]
encode' (xs:ys) = (encode'' xs):(encode' ys)

encode xs = encode' (pack xs)

--14 replicate elements of a list
--repli :: [a] -> [a]
--repli = foldl (:) []

--15 replicate elements of a list x times

