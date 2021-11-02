--Tema realizata de Sandu Raluca, grupa 242

--ex1) Scrieti o functie generică firstEl care are ca argument o listă de perechi
--de tip (a,b) si întoarce lista primelor elemente din fiecare pereche:
--firstEl [('a',3),('b',2), ('c',1)] va intoarce "abc"

firstEl :: [(a,b)] -> [a]
firstEl lista = map fst lista

--ex2) Scrieti functia sumList care are ca argument o listă de liste de valori Int
--si întoarce lista sumelor elementelor din fiecare listă (suma elementelor unei liste 
--de întregi se calculează cu functia sum)
--sumList [[1,3], [2,4,5], [], [1,3,5,6]] va intoarce [4,11,0,15]

sumList :: [[Int]] -> [Int]
sumList lista = map sum lista 

--ex3) Scrieti o functie prel2 care are ca argument o listă de Int si întoarce 
--o listă în care elementele pare sunt înjumătătite, iar cele impare sunt dublate:
--prel2 [2,4,5,6] va intoarce [1,2,10,3]

--varianta 1, definind o functie ajutatoare

prel2 :: [Int] -> [Int]
prel2 lista = map f lista where 
f :: Int -> Int
f x
  | even x = x `div` 2
  | otherwise = x * 2

--varianta 2, fara functie ajutatoare

prel22 :: [Int] -> [Int]
prel22 lista = map( \x -> if even x then x `div` 2 else x*2 ) $ lista

--ex4)Scrieti o functie care primeste ca argument un caracter si o listă de
--siruri, rezultatul fiind lista sirurilor care contin caracterul respectiv 
--(folositi functia elem).

func4 :: Char -> [String] -> [String]
func4 x lista = filter (elem x) lista


--ex5) Scrieti o functie care primeste ca argument o listă de întregi
--si întoarce lista pătratelor numerelor impare

func5 :: [Int] -> [Int]
func5 lista = map (^2)(filter odd lista)

--ex6) Scrieti o functie care primeste ca argument o listă de întregi si
--întoarce lista pătratelor numerelor din pozitii impare. Pentru a avea 
--acces la pozitia elementelor folositi zip

func6 :: [Int] -> [Int]
func6 list = map ((^2) . snd) (filter (odd . fst) (zip [1..length list] list))

--exemplu concret pentru a intelege mai bine functia
--pornim de la dreapta spre stanga. lista noastra va fi [12,23,3,9,10,11,12,20],
--iar lista de indici [1,2,3,4,5,6,7,8,9]

--aplicam zip pentru a crea perechi de tipul (indice, element)
--zip [1,2,3,4,5,6,7,8][12,23,3,9,10,11,12,20] = [(1,12),(2,23),(3,3),(4,9),(5,10),(6,11),(7,12),(8,20)]

--alegem doar perechile cu indicele impar 
--filter (odd . fst) [(1,12),(2,23),(3,3),(4,9),(5,10),(6,11),(7,12),(8,20)] = [(1,12),(3,3),(5,10),(7,12)]

--apoi, ridicam la patrat fiecare element(al doilea nr din pereche) si aplicam map pentru a face asta cu toate nr
--in final, vom obtine lista [144,9,100,144]

--ex7)Scrieti o functie care primeste ca argument o listă de siruri de caractere
--si întoarce lista obtinută prin eliminarea consoanelor din fiecare sir.
--numaiVocale ["laboratorul", "PrgrAmare", "DEclarativa"] va intoarce ["aoaou","Aae","Eaaia"]

numaiVocale :: [String] -> [String]
numaiVocale lista = map (filter (`elem` "aeiouAEIOU")) $ lista

--ex8)Definiti recursiv functiile mymap si myfilter cu aceeasi functionalitate 
--ca si functiile predefinite.

myMap :: (a -> b) -> [a] -> [b]
myMap _ [] = []
myMap f (x:xs) = f x : myMap f xs

myFilter :: (a -> Bool) -> [a] -> [a]
myFilter _ [] = []
myFilter p (x:xs) = if p x then x : myFilter p xs else myFilter p xs

--ex9)Calculati suma pătratelor elementelor impare dintr-o listă dată ca parametru.

func9 :: [Int] -> Int
func9 lista = sum (map (^2) (filter odd lista))

--ex10)Scrieti o functie care verifică faptul că toate elementele dintr-o listă sunt True, folosind foldr.

allTrue :: [Bool] -> Bool
allTrue lista = (foldr (&&) True) $ lista

--ex11)
--a)Scrieti o functie care elimină un caracter dintr-un sir de caractere.

rmChar :: Char -> String -> String
rmChar ch sir = [c | c <- sir, c /= ch] 

--b)Scrieti o functie recursivă care elimină toate caracterele din al doilea
--argument care se găsesc în primul argument, folosind rmChar.

rmCharsRec :: String -> String -> String
rmCharsRec _ [] = []
rmCharsRec de_sters (x:xs)
  | x `notElem` de_sters = x: rmCharsRec de_sters xs
  | otherwise            = rmCharsRec de_sters xs

--c)Scrieti o functie echivalentă cu cea de la (b) care foloseste foldr în locul recursiei si rmChar.

rmCharsFold :: String -> String -> String
rmCharsFold de_sters = foldr (\c -> if c `notElem` de_sters then (c:) else id) []

--functia identitate se foloseste astfel : id 3 va intoarce 3 