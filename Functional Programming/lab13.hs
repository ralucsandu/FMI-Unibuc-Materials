--Laborator 13
--Sandu Raluca-Ioana

--FOLDABLE

import Data.Monoid

--1. Implementati urmatoarele functii folosind foldMap/foldr din clasa Foldable,
--apoi testati-le cu mai multe tipuri care au instanta pentru Foldable

--a)
myElem :: (Foldable t, Eq a) => a -> t a -> Bool
myElem x = getAny . foldMap (Any . (==x))

myElem2 :: (Foldable t, Eq a) => a -> t a -> Bool
myElem2 a = foldr (\x y -> (x == a) || y) False

--exemplu test: myElem 3 [1,2,3] trebuie sa dea True

--b)
myNull :: (Foldable t) => t a -> Bool
myNull = getAll . foldMap (All . (const False))

--alta varianta
myNull2 :: (Foldable t) => t a -> Bool
myNull2 x = getAll $ foldMap (\y -> All False) x

--alta varianta
myNull3 :: (Foldable t) => t a -> Bool
myNull3 = foldr(\_ _ -> False) True

--exemplu test: myNull [Null, Null] sau myNull[2,3] da False, dar myNull[] da True

--c)
myLength :: (Foldable t) => t a -> Int 
myLength = getSum . foldMap (Sum . const  1)

--exemplu test: myLength [1,2,3] trebuie sa dea 3 (lungimea listei)

--d)
myToList1 :: (Foldable t) => t a -> [a]
myToList1 = foldr (:) []

myToList2 :: (Foldable t) => t a -> [a]
myToList2 = foldr (\x y -> x : y) []

--exemplu test: myToList [1,2,3,4,5,6,9] trebuie sa dea tot [1,2,3,4,5,6,9]

--e)--fold combina elementele unei structuri folosind structura de monoid a acestora.

myFold :: (Foldable t, Monoid m) => t m -> m
myFold = foldMap (id)

--exemplu test: myFold [[1,2,3], [4,5], [6], []] trebuie sa dea [1,2,3,4,5,6]

--2. Scrieti instante ale lui Foldable pentru urmatoarele tipuri, implementand functia foldMap.

--a)
data Constant a b = Constant b
instance Foldable (Constant a) where 
    foldMap f(Constant a) = f a 

--exemplu test: foldMap Sum (Constant 3) trebuie sa dea Sum{getSum = 3}

--b)
data Two a b = Two a b 
instance Foldable(Two a) where
    foldMap f(Two a b) = f b 

--exemplu test: foldMap Sum (Two 1 5) trebuie sa dea Sum{getSum = 5}

--c)
data Three a b c = Three a b c
instance Foldable(Three a b) where 
    foldMap f(Three a b c) = f c

--exemplu test: foldMap Sum (Three 1 5 9) trebuie sa dea Sum{getSum = 9}

--d) 
data Three' a b = Three' a b b 
instance Foldable(Three' a) where 
    foldMap f(Three' a b1 b2) = f b1 <> f b2 

--exemplu test: foldMap Sum (Three' 1 5 6) trebuie sa dea Sum{getSum = 11}

--e)
data Four' a b = Four' a b b b
instance Foldable(Four' a) where
    foldMap f(Four' a b1 b2 b3) = f b1 <> f b2 <> f b3

--exemplu test : foldMap Sum (Four' 1 5 6 8) trebuie sa dea Sum{getSum = 19}

--f)
data GoatLord a = NoGoat | OneGoat a | MoreGoats(GoatLord a) (GoatLord a) (GoatLord a)
instance Foldable GoatLord where 
    foldMap f NoGoat = mempty
    foldMap f (OneGoat a) = f a
    foldMap f (MoreGoats a b c) = foldMap f a <> foldMap f b <> foldMap f c 

--exemplu test: foldMap Sum (MoreGoats (OneGoat 4) NoGoat (MoreGoats (OneGoat 3) (OneGoat 7) NoGoat)) 
--trebuie sa dea Sum{getSum = 14} fiindca face suma 4+3+7