--Tema realizata de Sandu Raluca, grupa 242

--ex1
--a) Scrieti o functie ePortocalaDeSicilia care indică dacă un fruct este o portocală de Sicilia sau nu. 
--Soiurile de portocale din Sicilia sunt Tarocco, Moro si Sanguinello. 
--De exemplu, test_ePortocalaDeSicilia1 = ePortocalaDeSicilia (Portocala "Moro" 12) == True
--            test_ePortocalaDeSicilia2 = ePortocalaDeSicilia (Mar "Ionatan" True) == False

data Fruct
    = Mar String Bool
    | Portocala String Int

ePortocalaDeSicilia :: Fruct -> Bool
ePortocalaDeSicilia (Mar soi v) = False
ePortocalaDeSicilia (Portocala soi nr)
    |soi == "Tarocco" || soi == "Moro" || soi == "Sanguinello" = True
    |otherwise = False

--b)
--Scrieti o functie nrFeliiSicilia care calculează numărul total de felii ale portocalelor de Sicilia 
--dintr-o listă de fructe. De exemplu, test_nrFeliiSicilia = nrFeliiSicilia listaFructe == 52

--scurt exemplu pentru a ne aminti functia foldr 
--foldr (/) 2 [8,12,24,4] = 8, pasii fiind urmatorii:
--8/(12/(24/(4/2))) = 8/(12/(24/2)) = 8/(12/12) = 8/1 = 8

nrFeliiSicilia :: [Fruct] -> Int
nrFeliiSicilia listaFructe = foldr (+) 0 [nr | (Portocala soi nr) <- listaFructe, ePortocalaDeSicilia(Portocala soi nr)]

--c)
--Scrieti o functie nrMereViermi care calcuelază numărul de mere care au viermi dintr-o lista de fructe.
--De exemplu, test_nrMereViermi = nrMereViermi listaFructe == 2

areViermi :: Fruct -> Bool
areViermi (Portocala _ _) = False
areViermi (Mar _ False) = False
areViermi (Mar _ True) = True

nrMereViermi :: [Fruct] -> Int
nrMereViermi = length . filter (areViermi) --filter returneaza o lista cu elementele care respecta proprietatea data

--ex2

type NumeA = String
type Rasa = String

data Animal = Pisica NumeA | Caine NumeA Rasa
    deriving Show

--a)Scrieti o functie vorbeste care întoarce "Meow!" pentru pisică si "Woof!" pentru câine.

vorbeste :: Animal -> String
vorbeste (Pisica _) = "Meow!"
vorbeste (Caine _ _) = "Woof!"

--b)Vă reamintiti tipul de date predefinit Maybe data Maybe a = Nothing | Just a
--Scrieti o functie rasa :: Animal -> Maybe String care întoarce rasa unui câine 
--dat ca parametru sau Nothing dacă parametrul este o pisică.

rasa :: Animal -> Maybe String
rasa (Pisica _) = Nothing
rasa (Caine _ r) = Just r

--ex3. Se dau urmatoarele tipuri de date ce reprezintă matrici cu linii de lungimi diferite:

data Linie = L [Int]
    deriving Show
data Matrice = M [Linie]
    deriving Show

--a) Scrieti o functie care verifica daca suma elementelor de pe fiecare linie
--este egala cu o valoare n. Rezolvati cerinta folosind foldr.

--facem intai o functie ajutatoare care verifica daca suma elementelor unei linii este egala cu o valoare n

verifLinie :: Linie -> Int -> Bool
verifLinie (L l) n
  | sum l == n = True
  | otherwise = False

verifica :: Matrice -> Int -> Bool
verifica (M m) n = foldr(&&) True [verifLinie l n | l <- m]

--varianta fara functie ajutatoare

verificaa :: Matrice -> Int -> Bool
verificaa (M list) n = foldr (&&) True (map (\ (L l)-> sum l == n ) list)
 
--b) Scrieti o functie doarPozN care are ca parametru un element de tip Matrice
--si un numar intreg n, si care verifica daca toate liniile de lungime n din
--matrice au numai elemente strict pozitive.

--folosim functii ajutatoare

--functie pentru a verifica daca toate elementele unei linii sunt strict pozitive 

liniePoz :: Linie -> Bool
liniePoz (L l) = and [x > 0 | x <- l]

--functie pentru a verifica daca lungimea unei linii este n 

verifLung :: Linie -> Int -> Bool
verifLung (L l) n 
    | length l == n = True
    | otherwise = False

--functie care verifica daca toate liniile de lungime n din matrice au elemente > 0

doarPozN :: Matrice -> Int -> Bool
doarPozN (M m) n = foldr (&&) True [liniePoz l | l <- m, verifLung l n]

--c)Definiti predicatul corect care verifică dacă toate liniile dintr-o matrice au aceeasi lungime.

corect :: Matrice -> Bool
corect (M []) = True
corect (M [n]) = True
corect (M (L x : L  y:xs ))
    |length x == length y = corect (M(L y:xs))
    |otherwise = False 



