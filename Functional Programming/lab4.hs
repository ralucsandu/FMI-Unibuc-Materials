import Data.Char
import Data.List 

--1)Folosind numai metoda prin selectie definiti o functie factori 
--atfel încât factori n întoarce lista divizorilor pozitivi ai lui n.

factori :: Int -> [Int]
factori 0 = [0]
factori x = [d | d <- [1..x],  x `mod` d == 0]

--2)Folosind functia factori, definiti predicatul prim n care întoarce True dacă si numai dacă n este număr prim.

--stim ca un numar este prim daca are exact 2 divizori
prim :: Int -> Bool
prim x = length(factori x) == 2 

--3)Folosind numai metoda prin selectie si functiile definite anterior, definiti functia numerePrime
--astfel încât numerePrime n întoarce lista numerelor prime din intervalul [2..n]

numerePrime :: Int -> [Int]
numerePrime x = [p | p <-[2..x], prim p == True]

--4) Definiti functia myzip3 care se comportă asemenea lui zip dar are trei argumente.
--Atentie: pentru zip [1..5][1..3] se va afisa [(1,1),(2,2),(3,3)] deoarece a doua lista se termina cu 3

myzip3 :: [Int] -> [Int] -> [Int] -> [(Int, Int, Int)]
myzip3 [] _ _ = []
myzip3 _ [] _ = []
myzip3 _ _ [] = []
myzip3 lista1 lista2 lista3 = [(x,y,z) | ((x,y), z) <- zip (zip lista1 lista2) lista3]

--5)Folosind metoda prin selectie, functia and si functia zip, completati definitia functiei ordonataNat 
--care verifică dacă o listă de valori Int este ordonată, relatia de ordine fiind cea naturală

ordonataNat :: [Int] -> Bool
ordonataNat [] = True
ordonataNat [x] = True
ordonataNat (x:xs) = and [a <= b | (a, b) <- zip (x:xs) xs]

--6)Folosind doar recursie, definiti functia ordonataNat1, care are acelasi comportament cu functia de mai sus.
--exemplu pentru x:xs. Pentru lista [1,2,3,4], x=1 si xs=[2,3,4]

ordonataNat1 :: [Int] -> Bool
ordonataNat1 [] = True
ordonataNat1 [x] = True
ordonataNat1 (x:xs) 
    | x <= head xs = ordonataNat1 xs
    | otherwise = False

--7)Scrieti o functie ordonata generică cu tipul de mai jos, care primeste ca argumente o listă de elemente si o
--relatie binară pe elementele respective. Functia întoarce True dacă oricare două elemente consecutive sunt în relatie.

ordonata :: [a] -> (a -> a -> Bool) -> Bool
ordonata [] _ = True
ordonata [x] _ = True
ordonata (x:xs) relbinara
    | x `relbinara` (head xs) = ordonata xs relbinara
    | otherwise = False

--8)Definiti un operator *<*, asociativ la dreapta, cu precedenta 6, cu signatura (*<*) :: (Integer, Integer) -> (Integer, Integer) -> Bool
--care defineste o relatie pe perechi de numere întregi (alegeti voi relatia).

--Facem ca operatorul < sa verifice daca ambele elemente din prima pereche sunt mai mici decat ambele elemente din cea de-a doua pereche
--de exemplu, pentru (1,5) (2,3) se va afisa False, iar pentru (1,1) (4,8) se va afisa True

(*<*) :: (Integer, Integer) -> (Integer, Integer) -> Bool
(*<*) (x,y) (z,t)
    | x < z && x < t && y < z && y < t = True
    | otherwise = False

--aceeasi functie, dar folosind functia ordonata 

(**<**) :: (Integer, Integer) -> (Integer, Integer) -> Bool
(**<**) (x,y) (z,t) = ordonata([x,z])(<) && ordonata ([x,t])(<) && ordonata ([y,z])(<) && ordonata ([y,t])(<)


--9) Scrieti o functie compuneList  care primeste ca argumente o functie si o listă de functii si 
--întoarce lista functiilor obtinute prin compunerea primului argument cu fiecare functie din al doilea argument.

compuneList :: (b -> c) -> [(a -> b)] -> [( a -> c)]
compuneList f listafunctii = [f . g | g <- listafunctii]

--10)Scrieti o functie aplicaList care primeste un argument de tip a si o listă de functii de tip a -> b 
--si întoarce lista rezultatelor obtinute prin aplicarea functiilor din listă pe primul argument:

aplicaList :: a -> [(a -> b)] -> [b]
aplicaList x listafunctii = [f x | f <- listafunctii]

