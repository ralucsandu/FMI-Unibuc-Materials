--Tema realizata de : Sandu Raluca-Ioana 
--Grupa: 242

--ex1.
-- functie rotate care pt un nr n>0 si n<lungimea listei, va roti lista cu n elemente.
-- functia arunca eroare daca n<0 sau n>lungimea listei 
import Control.Exception
import Data.Char

rotate :: Int -> [Char] -> [Char]
rotate n lista 
    | n < 0 = error "n este numar negativ"
    | n > length(lista) = error "n > lungimea listei date"
    | otherwise = drop n lista ++ take n lista

--ex3.
--Folosind functia rotate, scrieti o functie makeKey :: Int -> [(Char, Char)] care
--intoarce cheia de criptare cu o anumită deplasare pentru lista de litere mari ale
--alfabetului englez.

makeKey :: Int -> [(Char, Char)]
makeKey n = zip litere (rotate n litere)
    where litere = ['A'..'Z']

--ex4. 
--Scrieti o functie lookUp :: Char -> [(Char, Char)] -> Char care caută o pereche
--după prima componentă si întoarce a doua componentă a acesteia. Dacă nu există
--o pereche cu caracterul căutat pe prima pozitie, functia întoarce caracterul dat ca parametru.

lookUp :: Char -> [(Char, Char)] -> Char
lookUp c [] = c
lookUp c (x:xs)
    | fst x == c = snd x
    | otherwise = lookUp c xs

--ex5.
--Scrieti o functie encipher :: Int -> Char -> Char care criptează un caracter
--folosind cheia dată de o deplasare dată ca parametru.

encipher :: Int -> Char -> Char
encipher key value = lookUp value (makeKey key)

--ex6.
--Pentru a fi criptat, textul trebuie să nu contină semne de punctuatie si să fie scris
--cu litere mari. Scrieti o functie normalize :: String -> String care normalizează un sir, 
--transformând literele mici în litere mari si eliminând toate caracterele care nu sunt litere sau cifre.

normalize :: String -> String
normalize "" = ""
normalize (x:xs)
  | isAlphaNum x = toUpper x : normalize xs
  | otherwise = normalize xs

--ex7.
--Scrieti o functie encipherStr :: Int -> String -> String care normalizează un sir
--si îl criptează folosind functiile definite anterior.

encipherStr :: Int -> String -> String
encipherStr n sir = [encipher n sir | sir <- normalize sir]

--alta varianta: encipherStr n sir = map(encipher n)(normalize sir)

--ex8.
--Scrieti o functie reverseKey :: [(Char, Char)] -> [(Char, Char)] pentru a inversa
--cheia de criptare, schimbând componentele din fiecare pereche între ele.

reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey lista = [(y,x) | (x,y) <- lista]

--ex9.
--Scrieti functiile decipher :: Int -> Char -> Char si decipherStr :: Int -> String -> String
--pentru a decripta un caracter si un string folosind cheia generată de o deplasare dată.
--Functia va lăsa nemodificate cifrele si spatiile, dar va sterge literele mici sau alte caractere.

decipher :: Int -> Char -> Char
decipher n ch = lookUp ch (reverseKey(makeKey n))

decipherStr :: Int -> String -> String
decipherStr n sir = [decipher n ch | ch <- sir]