import Data.List
import Data.Maybe

--2: Sum of even fibonacci numbers below 4 million
fib :: [Int] -> [Int]
fib all@(x:y:_) = (x+y):all

loopFib :: Int -> [Int] -> [Int]
loopFib 0 x = x
loopFib x y = loopFib (x-1) (fib y)

fibEvenSum :: Int
fibEvenSum = sum . filter (even) . takeWhile (<4000001) . reverse $ loopFib 1000 [1,1]

-- 14: longest collatz chain starting at < 1,000,000


largestIndex xs = (+) 1 . fromJust $ findIndex (== maximum xs) xs

cChain :: Int -> [Int]
cChain x
    | x == 1 = x:[]
	| even x = x:cChain (x`div`2)
	| odd x = x:cChain (3*x + 1)

cGreatestLength :: Int -> Int
cGreatestLength x = largestIndex . map length $ map cChain [1..x]

--17: number letter counts

getRevDigits :: Int -> [Int]
getRevDigits 0 = []
getRevDigits x = (mod x 10):(getRevDigits (div x 10))

digWord :: Int -> String
digWord x =
    case x of
	    0 -> "";
		1 -> "one";
		2 -> "two";
		3 -> "three";
		4 -> "four";
		5 -> "five";
		6 -> "six";
		7 -> "seven";
		8 -> "eight";
		9 -> "nine"

tensWord :: Int -> String
tensWord x =
    case x of
	    2 -> "twenty";
		3 -> "thirty";
		4 -> "forty";
		5 -> "fifty";
		6 -> "sixty";
		7 -> "seventy";
		8 -> "eighty";
		9 -> "ninety"

teensWord :: Int -> String
teensWord x =
    case x of
	    0 -> "ten";
		1 -> "eleven";
		2 -> "twelve";
		3 -> "thirteen";
		4 -> "fourteen";
		5 -> "fifteen";
		6 -> "sixteen";
		7 -> "seventeen";
		8 -> "eighteen";
		9 -> "nineteen"

numWord :: [Int] -> String
numWord (x:y:z:[]) = (digWord z) ++ "hundred" ++ (if y+x > 0 then "and" else "") ++ (numWord (x:y:[]))
numWord (x:y:[])
    | y > 1 = tensWord y ++ digWord x
	| y == 1 = teensWord x
	| otherwise = numWord [x]
numWord (x:[]) = digWord x

numWordCount x = sum . map length . map numWord $ map getRevDigits [1..x]