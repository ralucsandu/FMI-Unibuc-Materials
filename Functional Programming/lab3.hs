import Data.Char

--1)functie nrVocale care pt o lista de siruri de caractere, calculeaza nr total de vocale ce apar in cuvintele palindrom

--Pentru a verifica daca un sir e palindrom, puteti folosi functia reverse, iar pentru a cauta un element într-o lista puteti folosi functia elem.
--Puteti folosi functii auxiliare

--functia palindrom
palindrom :: String -> Bool
palindrom x = 
            if x == reverse x 
                then True 
                else False

--functie ce calculeaza nr de vocale dintr-un singur cuvant
vocaleCuvant :: String -> Int
vocaleCuvant [] = 0
vocaleCuvant (x:xs) = 
        if (x) `elem` ['a','A','e','E','i','I','o','O','u','U'] 
            then 1 + vocaleCuvant(xs)
            else vocaleCuvant(xs)

--functia nrVocale
nrVocale :: [String] -> Int
nrVocale [] = 0
nrVocale (x:xs) =
            if palindrom (x) 
                then vocaleCuvant (x) + nrVocale (xs) 
                else nrVocale (xs)


--2)Sa se scrie o functie care primeste ca parametru un numar si o lista de întregi 
--si adauga elementul dat dupa fiecare element par din lista.

f :: Int -> [Int] -> [Int]
f _ [] = []
f nr (x:xs)
  | x `mod` 2 == 0 = x:nr:(f nr xs)
  | otherwise = x:(f nr xs)


--3)functie care are ca parametru un nr intreg si determina lista de divizori a acestui nr

divizori :: Int -> [Int]
divizori 0 = [1]
divizori x = [d | d <- [1..x], x `mod` d == 0 ]


--4)functie care are ca parametru o lista de nr intregi si calculeaaza lista listelor de divizori

--y <- x inseamna ca y ia valori din lista x 

listadiv :: [Int] -> [[Int]]
listadiv x = [divizori y | y <-x ]

--5)Scrieti o functie care date fiind limita inferioara si cea superioara (întregi) a unui interval
--închis si o lista de numere întregi, calculeaza lista numerelor din lista care apartin intervalului.

--b)comprehension

inIntervalComp :: Int -> Int -> [Int] -> [Int]
inIntervalComp a b lista = [x | x <- lista, x >=a, x <=b]

--a)recursiv

inIntervalRec :: Int -> Int -> [Int] -> [Int]
inIntervalRec _ _ [] = []
inIntervalRec a b (x:xs)    --x este capul listei, iar xs coada listei
  | a <= x && x <= b = x : inIntervalRec a b xs
  | otherwise = inIntervalRec a b xs

--6)Scrieti o functie care numara câte numere strict pozitive sunt într-o lista data ca argument.

--a)recursiv

pozitiveRec :: [Int] -> Int
pozitiveRec [] = 0
pozitiveRec (x:xs)
  | x > 0 = 1 + pozitiveRec xs
  | otherwise = pozitiveRec xs

--b)comprehension
pozitiveComp :: [Int] -> Int
pozitiveComp lista = length [x | x<-lista, x>0]

--7)functie care data fiind o lista de numere calculeaza lista pozitiilor elementelor impare din lista originala.

-- pozitiiImpare [0,1,-3,-2,8,-1,6,1] == [1,2,5,7]

--a)recursiv

pozitiiImpareRecAux :: Int -> [Int] -> [Int]

pozitiiImpareRec :: [Int] -> [Int]
pozitiiImpareRecAux _ [] = []
pozitiiImpareRecAux i (x:xs)   --indicele i se plimba prin coada
  | x `mod` 2 == 1 = i : pozitiiImpareRecAux (i+1) xs
  | otherwise = pozitiiImpareRecAux (i+1) xs  --aici tai din lista mea elementele care nu respecta conditia

pozitiiImpareRec l = pozitiiImpareRecAux 0 l

--b)comprehension

--zip ul ia primul element din prima, apoi primul din al doilea si tot asa pana se termina una dintre cele doua liste
--1,2,3 zip a,c,b,d (1,a), (2,c)...

pozitiiImpareComp :: [Int] -> [Int]
pozitiiImpareComp lista = [p | (el,p) <- zip lista [0..], el `mod` 2 == 1] --p este indicele si el elementul



--8)functie care calculeaza produsul tuturor cifrelor care apar în sirul de caractere dat ca intrare. 
--Daca nu sunt cifre în sir, raspunsul functiei trebuie sa fie 1 .

-- multDigits "The time is 4:25" == 40
-- multDigits "No digits here!" == 1

--a)varianta recursiva

multDigitsRec ::  String -> Int
multDigitsRec "" = 1
multDigitsRec (x:xs)
  | isDigit x = digitToInt x * multDigitsRec xs
  | otherwise = multDigitsRec xs


--b)comprehension

multDigitsComp :: String -> Int
multDigitsComp sir = product [digitToInt n | n <- sir, isDigit n]
