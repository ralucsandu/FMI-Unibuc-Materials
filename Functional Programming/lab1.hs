maxim x y = if (x > y)
                then x 
            else y

--maxim3 x y z = maxim x (maxim y z)

--maxim3 x y z = let u = (maxim x y) in (maxim u z)

--scriem functia maxim3 fara a ne folosi de functia maxim, ci de functia predefinita max 
--maxim3 x y z = 
--    let a = max x y in 
--        max a z 

maxim3 x y z =
    let 
        u = maxim x y
    in 
        maxim u z

--functia maxim4 folosind varianta cu let .. in si indentare
maxim4 x y z t = 
    let 
        u = maxim3 x y z
    in 
        maxim u t

--functie cu 2 parametri care calculeaza suma pătratelor celor două numere
suma_patrate x y = x * x + y * y

--functie cu un parametru ce întoarce mesajul “par” dacă parametrul este par si “impar” altfel;
paritate x =  if mod x 2 == 0 then "par" else "impar"

--functie care calculează factorialul unui număr;
factorial x = product [1..x]

--functie care verifică dacă primul parametru este mai mare decât dublul celui de-al doilea parametru.
functie x y = if (x > 2*y) then "da" else "nu"
