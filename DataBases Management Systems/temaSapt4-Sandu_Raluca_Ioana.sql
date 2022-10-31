--Tema saptamana 4 curs SGBD
--Realizata de : Sandu Raluca-Ioana
--Grupa 242

--ex1.
DECLARE
    TYPE tab_imb IS TABLE OF NUMBER;
--  t tab_imb;                  
    t tab_imb := tab_imb(1,2,3,4,5);
    t_null tab_imb;
BEGIN
--    t(11) :=11;
--    t(12) :=12;
--    t(-1) := 99;
    t.EXTEND(6);
    FOR i IN 6..10 LOOP
    t(i):=i;
    END LOOP;
DBMS_OUTPUT.PUT('Tabloul are ' || t.COUNT ||' elemente:');
FOR i IN t.FIRST..t.LAST LOOP
    DBMS_OUTPUT.PUT(t(i) || ' ');
END LOOP;
DBMS_OUTPUT.NEW_LINE;
DBMS_OUTPUT.PUT_LINE('Elementul de la pozitia 11 este ' || t(11)); 
--DBMS_OUTPUT.PUT_LINE('Elementul de la pozitia 12 este ' || t(12)); 
DBMS_OUTPUT.PUT_LINE('Elementul de la pozitia -1 este ' || t(-1));
t := t_null;
IF t IS NULL THEN
    DBMS_OUTPUT.PUT_LINE('Colectie atomic null');
END IF;
EXCEPTION
    WHEN COLLECTION_IS_NULL THEN
        DBMS_OUTPUT.PUT_LINE('Colectia este nula! Necesita initializare!');
    WHEN SUBSCRIPT_BEYOND_COUNT THEN
        DBMS_OUTPUT.PUT_LINE('Indexul este prea mare! Introduceti unul care se afla in domeniu!');
    WHEN SUBSCRIPT_OUTSIDE_LIMIT THEN
        DBMS_OUTPUT.PUT_LINE('Indexul este prea mic! Introduceti unul care se afla in domeniu!');
END;

--Observam ca daca incercam sa atribuim valori elementelor de la pozitiile 11 si 12 vom obtine 
--o eroare de tipul "Subscript beyond count", deoarece nu am dat inca extend tabloului imbricat, asa ca
--indicii acestia nu exista.

--Daca incercam sa afisam valoarea elementului de la pozitia 11, nu vom obtine eroare, ci se va afisa 
--un spatiu, deoarece am dat extend(6) tabloului, deci s-a creat o pozitie si pentru cel de-al 11-lea 
--element, insa acesta nu a fost initializat cu o valoare. Alt exemplu de situatie pentru care s-ar intampla acelasi
--lucru ar fi daca am da extend(7) si am incerca sa afisam elementul de la pozitia 12 
--fara a-l initializa in prealabil.

--Daca incercam sa afisam valoarea elementului de la pozitia 12, vom obtine eroarea 
--"Subscript beyond count", deoarece nu am extins suficient tabloul imbricat. Tratand aceasta exceptie
--in blocul corespunzator, se va afisa mesajul "Indexul este prea mare! Introduceti unul care se afla in domeniu!".
--Alte exemple de numere pentru care va aparea aceasta eroare, sunt toate numerele strict mai mari decat 11.

--In cazul in care incercam sa atribuim valori elementului de la pozitia -1, vom obtine o eroare
--de tipul "Subscript outside limit", deoarece indicele este in afara domeniului(in mod normal, indicele
--pleaca de la 1 in tablourile imbricate). Acest lucru va fi valabil si pentru cazul in care incercam sa
--afisam elementul de la pozitia -1. Alte exemple de numere care ar genera aceeasi situatie, sunt toate 
--numerele mai mici sau egale cu 0. 

--Pentru a intra in cazul in care se afiseaza eroarea "Reference to uninitialized collection", trebuie
--sa comentam linia la care am initializat tabloul cu elemente de la 1 la 5, lasand doar "t tab_imb;".
--Practic, in acest mod incercam sa lucram pe o colectie in care nu a fost facut spatiu pentru nimic.

--ex2
--Creati un exercitiu asemanator cu EX1 folosind tablou indexat si in care sa stergeti primul si 
--ultimul element si 2 elemente din interior. Afisati numarul de elemente din tablou, cat si 
--fiecare element ramas. Discutati ce exceptii pot aparea.

DECLARE 
    TYPE tablou_indexat IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    traluca tablou_indexat;
BEGIN
    FOR valoare in 1..15 LOOP 
        traluca(valoare) := valoare;
    END LOOP;
--  DBMS_OUTPUT.PUT_LINE(traluca(19));
    DBMS_OUTPUT.PUT_LINE('Tabloul are initial ' || traluca.count || ' elemente ');
    DBMS_OUTPUT.PUT('Elementele sunt: ');
    FOR valoare in traluca.first..traluca.last LOOP
        DBMS_OUTPUT.PUT(traluca(valoare) || ' ');
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    --stergem primul si ultimul element
    traluca.DELETE(traluca.first);
    traluca.DELETE(traluca.last);
    --stergem 2 elemente din interior 
    traluca.DELETE(6);
    traluca.DELETE(13);
    DBMS_OUTPUT.PUT_LINE('Dupa stergere, in tablou au ramas ' || traluca.count || ' elemente ');
    DBMS_OUTPUT.PUT('Elementele sunt: ');
    FOR valoare in traluca.first..traluca.last LOOP
        IF traluca.EXISTS(valoare) then
            DBMS_OUTPUT.PUT(traluca(valoare) || ' ');
        END IF;
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Elementul nu a fost gasit!');
END;
    
--Exceptia ce poate aparea in acest caz este cea de NO DATA FOUND. Aceasta apare atunci cand incercam
--utilizarea unui element caruia nu i s-a atribuit nicio valoare. In cazul nostru, la linia 8, daca
--incercam sa afisam elementul de la pozitia 19(sau orice alta pozitie >15), se va declansa aceasta
--exceptie, pe care am tratat-o in blocul EXCEPTION. Astfel, se va afisa in DBMS OUTPUT un mesaj 
--sugestiv. Aceeasi exceptie apare si in cazul in care vrem sa afisam elemente care au fost sterse 
--din baza de date. De aceea, folosim functia EXISTS. 