import Data.Maybe
import Data.List
import Data.Char
type Nume = String
data Prop
  = Var Nume
  | F
  | T
  | Not Prop
  | Prop :|: Prop
  | Prop :&: Prop
  | Prop :->: Prop
  | Prop :<->: Prop
  deriving Eq
infixr 1 :->:
infixr 1 :<->:
infixr 2 :|:
infixr 3 :&:


--Ex1

--1.(P ∨ Q) ∧ (P ∧ Q)
p1 :: Prop
p1 = (Var "P" :|: Var "Q") :&: (Var "P" :&: Var "Q")

--2.(P ∨ Q) ∧ (¬P ∧ ¬Q)
p2 :: Prop
p2 = (Var "P" :|: Var "Q") :&: (Not (Var "P") :&: Not (Var "Q"))

--3.(P ∧ (Q ∨ R)) ∧ ((¬P ∨ ¬Q) ∧ (¬P ∨ ¬R))
p3 :: Prop
p3 =
    (Var "P" :&: (Var "Q" :|: Var "R"))
        :&: ((Not (Var "P") :|: Not (Var "Q")) :&: (Not (Var "P") :|: Not (Var "R")))

--Ex2
--Faceti tipul Prop instanta a clasei de tipuri Show, înlocuind conectivele Not, :|: si :&:
--cu ~, | si & si folosind direct numele variabilelor în loc de constructia Var nume.

instance Show Prop where
    show (Var x) = x
    show F = "False"
    show T = "True"
    show (Not x) =  "(~" ++  show  x ++ ")"
    show (x :|: y) =  "(" ++  show  x ++ "|" ++ show  y ++ ")"
    show (x :&: y) =  "(" ++  show  x ++ "&" ++ show  y ++ ")"
    show (x :->: y) = "(" ++ show x ++ "<->" ++ show y ++ ")"
    show (x :<->: y) = "(" ++ show x ++ "<->" ++ show y ++ ")"
test_ShowProp :: Bool 
test_ShowProp = show (Not (Var "P") :&: Var "Q") == "((~P)&Q)"

--EX3
--Definiti o functie eval care dat fiind o expresie logică si 
--un mediu de evaluare, calculează valoarea de adevăr a expresiei.

type Env = [(Nume, Bool)]
env :: Env
env = [("P",True), ("Q",False)]

impureLookup :: Eq a => a -> [(a,b)] -> b
impureLookup a = fromJust  . lookup a

eval :: Prop -> Env -> Bool
eval F _ = False
eval T _ = True
eval (Var p) e = impureLookup p e
eval (Not p) e = not (eval p e)
eval (prop1 :|: prop2) e = eval prop1 e || eval prop2 e
eval (prop1 :&: prop2) e = eval prop1 e && eval prop2 e

test_eval = eval (Var "P" :|: Var "Q") [("P", True), ("Q", False)]

--EX4. Definiti o functie variabile care colectează lista tuturor variabilelor
--dintr-o formulă. Indicatie: folositi functia nub.

variabile :: Prop -> [Nume]
variabile F = []
variabile T = []
variabile (Var p)=[p]
variabile (Not prop )=variabile prop
variabile (prop1 :|: prop2)= nub (variabile prop1 ++ variabile prop2)
variabile (prop1 :&: prop2)= nub (variabile prop1 ++ variabile prop2)

test_variabile = variabile (Not (Var "P") :&: Var "Q")


--EX5
--Dată fiind o listă de nume, definiti toate atribuirile de valori de adevăr 
--posibile pentru ea.

--varianta 1
envs :: [Nume] -> [Env]
envs nume = sequence [[(x,y)|y<-[False, True]]|x<-nume]

--varianta 2
produsCartezian :: [a] -> Int -> [[a]]
produsCartezian nume 1 = [[x] | x <- nume]
produsCartezian nume n = [x : xs | x <- nume, xs <- produsCartezian nume (n - 1)]

envs2 :: [Nume] -> [Env]
envs2 [] = []
envs2 ls = [zip ls c | c <- produsCartezian [False, True] (length ls)]


test_envs2 =
    envs2 ["P", "Q"]
    ==
    [[("P",False)
     ,("Q",False)
     ]
    ,[("P",False)
     ,("Q",True)
     ]
    ,[("P",True)
     ,("Q",False)
     ]
    ,[("P",True)
     ,("Q",True)
     ]
    ]

--EX6
--Definiti o functie satisfiabila care dată fiind o Propozitie verifică dacă 
--aceasta este satisfiabilă. Puteti folosi rezultatele de la exercitiile 4 si 5

satisfiabila :: Prop -> Bool
--satisfiabila p = foldr ((||) . eval p) False (envs (variabile p)) prima varianta
satisfiabila p = or[eval p x | x <- (envs (variabile p))]   --a doua varianta
 
test_satisfiabila1 = satisfiabila (Not (Var "P") :&: Var "Q")
test_satisfiabila2 = satisfiabila (Not (Var "P") :&: Var "P")

--EX7
--O propozitie este validă dacă se evaluează la True pentru orice interpretare a varibilelor.
--O formulare echivalenta este aceea că o propozitie este validă dacă negatia ei este
--nesatisfiabilă. Definiti o functie valida care verifică dacă o propozitie este validă.

--prima varianta
valida :: Prop -> Bool
valida p = and [eval p x | x <-(envs(variabile p))] 

--a doua varianta; stim ca o prop e valida <=>negatia prop nu e satisfiabila
validaa :: Prop -> Bool
validaa p = not (satisfiabila(Not p))

test_valida1 = valida (Not (Var "P") :&: Var "Q")
test_valida2 = valida (Not (Var "P") :|: Var "P")

test_validaa1 = validaa (Not (Var "P") :&: Var "Q")
test_validaa2 = validaa (Not (Var "P") :|: Var "P")

--EX10
--Două propozitii sunt echivalente dacă au mereu aceeasi valoare de adevăr, 
--indiferent de valorile variabilelor propozitionale. Scrieti o functie care 
--verifică dacă două propozitii sunt echivalente.

--facem intai o functie auxiliara pt a verifica daca doua liste sunt egale

listeEgale :: (Eq a) => [a] -> [a] -> Bool
listeEgale [] [] = True
listeEgale _ [] = False
listeEgale [] _ = True
listeEgale(x:xs) (y:ys)
    | x /= y = False
    | otherwise = listeEgale xs ys

echivalenta :: Prop -> Prop -> Bool
echivalenta p q = listeEgale rezultat_p rezultat_q
  where
    var = nub ((variabile p)++(variabile(q)))  --functia nub elimina duplicatele
    rezultat_p = [eval p x | x <- (envs var)]
    rezultat_q = [eval q x | x <- (envs var)]


test_echivalenta1 = 
    True
    ==
    (Var "P" :&: Var "Q") `echivalenta` (Not (Not (Var "P") :|: Not (Var "Q")))

test_echivalenta2 =
  False
  ==
  (Var "P") `echivalenta` (Var "Q")

test_echivalenta3 = 
    True
    ==
    (Var "R" :|: Not (Var "R")) `echivalenta` (Var "Q" :|: Not (Var "Q"))
