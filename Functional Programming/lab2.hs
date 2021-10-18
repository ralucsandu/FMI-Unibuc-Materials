--ex1
poly2 :: Double -> Double -> Double -> Double -> Double
poly2 a b c x = let 
                ecuatie = a*x*x + b*x + c
                in ecuatie

--ex2
eeny :: Integer -> String 
eeny x | even x = "eeny"
       | otherwise = "meeny"

--ex3 varianta cu if
fizzbuzz1 :: Integer -> String
fizzbuzz1 x = 
    if x `mod` 15 == 0 then "FizzBuzz"
    else if x `mod` 5 == 0 then "Buzz"
    else if x `mod` 3 == 0 then "Fizz"
    else []

--ex3 varianta cu garzi(conditii)
fizzbuzz2 :: Integer -> String
fizzbuzz2 x | x `mod` 15 == 0 = "FizzBuzz"
            | x `mod` 5 == 0 = "Buzz"
            | x `mod` 3 == 0 = "Fizz"
            | otherwise = []

--al n-lea termen fibo metoda 1
fibonacciCazuri :: Integer -> Integer
fibonacciCazuri n | n < 2 = n
                  | otherwise = fibonacciCazuri (n - 1) + fibonacciCazuri (n - 2)

--al n-lea termen fibo metoda 2
fibonacciEcuational :: Integer -> Integer
fibonacciEcuational 0 = 0
fibonacciEcuational 1 = 1
fibonacciEcuational n = fibonacciEcuational (n - 1) + fibonacciEcuational (n - 2)

--ex4 tribonacci cu cazuri
tribonacciCazuri :: Integer -> Integer 
tribonacciCazuri n | n == 1 = 1
                   | n == 2 = 1
                   | n == 3 = 2
                   | otherwise = tribonacciCazuri(n-1) + tribonacciCazuri (n-2) + tribonacciCazuri (n-3)

--ex4 tribonacci ecuational
tribonacciEcuational :: Integer -> Integer 
tribonacciEcuational 1 = 1
tribonacciEcuational 2 = 1
tribonacciEcuational 3 = 2
tribonacciEcuational n = tribonacciCazuri(n-1) + tribonacciCazuri (n-2) + tribonacciCazuri (n-3)

--ex5 functie care calculeaza coeficientii binomiali, folosind recursivitate 
binomial :: Integer -> Integer -> Integer
binomial n 0 = 1
binomial 0 k = 0
binomial n k = binomial(n-1)k + binomial (n-1)(k-1)

--ex6a) functie care verifică dacă lungimea unei liste date ca parametru este pară
verifL :: [Int] -> Bool
verifL lista | even (length lista) = True
             | otherwise = False 

--varianta 2 ex 6a)
verifLL :: [Int] -> Bool
verifLL lista | length lista `mod` 2 == 0 = True
              | otherwise = False 

--ex6b)functie care pentru o listă dată ca parametru si un număr n, întoarce lista cu ultimele n elemente. 
--Dacă lista are mai putin de n elemente, se intoarce lista nemodificată.

takefinal :: [a] -> Int -> [a]
takefinal lista n = drop ((length lista)-n)(lista)

--ex6c)pentru o listă si un număr n se întoarce lista din care se sterge elementul de pe pozitia n.
remove :: [Int] -> Int -> [Int] 
remove lista n = (take n lista) ++ (drop (n+1)lista)

--ex7a) functie care pentru un întreg n si o valoare v întoarce lista de lungime n ce are doar elemente egale cu v. 
myreplicate:: Int-> Int-> [Int]
myreplicate n v = replicate n v

--ex7b) functie care pentru o listă de numere întregi, calculează suma valorilor impare. prima varianta-fara recursivitate
sumImp:: [Int]-> Int
sumImp n = sum (filter odd n)

--ex7b) cu recursivitate 
sumaImp :: [Int] -> Int
sumaImp [] = 0
sumaImp (x:xs)
  | x `mod` 2 == 1 = x + sumaImp xs
  | otherwise = sumaImp xs

--ex7c)functie care pentru o listă de siruri de caractere, calculează suma lungimilor sirurilor care încep cu caracterul ‘A’.
totalLen :: [String] -> Int
totalLen [] = 0
totalLen (h:t)
  | head h == 'A' = length h + totalLen t
  | otherwise = totalLen t

