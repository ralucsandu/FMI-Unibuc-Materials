--Sandu Raluca Ioana
--grupa 242

--Ex1 
--a) Scrieti o functie care numara cate propozitii sunt intr-un text dat. 
--Puteti scrie o functie auxiliara sfChr care verifica daca un caracter e sfarsit de propozitie. 

sfChr :: Char -> Bool
sfChr c | c `elem` ".?!:" = True
        | otherwise = False

countSentences :: String -> Int 
countSentences "" = 0 
countSentences (x:xs) | sfChr x == True = 1 + countSentences xs
                      | otherwise = countSentences xs

--b) Rezolvati acelasi exercitiu folosind doar metoda prin selectie. 

countSentences2 :: String -> Int 
countSentences2 text = length [x | x <- text, sfChr x == True ]

--Ex2
--Scrieti o functie liniiN care are ca parametru o matrice de nr intregi si un nr intreg n si verifica
--daca toate liniile de lungime n din matrice au doar elemente strict pozitive. 
--Folositi functii de nivel inalt. 

liniiN :: [[Int]] -> Int -> Bool
liniiN mat n = and [and (map (\x -> x>0) y) | y <- ( filter (\x -> length x == n) mat )]

--Ex3
--Se dau urmatoarele tipuri de date ce reprezinta puncte cu nr variabil de coordonate intregi:

data Punct = Pt [Int]
             deriving Show

--Arbori cu informatia in frunze si clasa de tipuri ToFromArb

data Arb = Vid | F Int | N Arb Arb 
           deriving Show 

class ToFromArb a where 
      toArb :: a -> Arb 
      fromArb :: Arb -> a 

--Sa se scrie o instanta a clasei ToFromArb pentru tipul de date Punct astfel incat
--coordonatele punctului sa coincida cu frontiera arborelui

--toArb(Pt [1,2,3])
--  N (F 1) (N (F 2) (N (F 3) Vid))
--fromArb $ N (F 1) (N (F 2) (N(F 3) Vid)) :: Punct
--  Pt [1,2,3]

--redefinim operatorul de concatenare

(+++) :: Punct -> Punct -> Punct 
(+++) (Pt a) (Pt b) = Pt (a++b)

instance ToFromArb Punct where 
    toArb(Pt[]) = Vid 
    toArb (Pt (x:xs)) = N (F x) (toArb (Pt xs))
    fromArb Vid = Pt []
    fromArb (F x) = Pt [x]
    fromArb (N x y) = (fromArb x) +++ (fromArb y)