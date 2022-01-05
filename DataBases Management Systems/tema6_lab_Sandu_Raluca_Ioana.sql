--Tema 6 laborator SGBD
--Realizata de: Sandu Raluca-Ioana
--Grupa: 242

--ex2.
--Definiti un tip colectie denumit tip_orase_***. Creati tabelul excursie_*** cu urmatoarea structura: 
--cod_excursie NUMBER(4), denumire VARCHAR2(20), orase tip_orase_*** (ce va contine lista 
--oraselor care se viziteaza într-o excursie, într-o ordine stabilita; de exemplu, primul oras din lista
--va fi primul oras vizitat), status (disponibila sau anulata). 
--a. Inserati 5 înregistrari în tabel. 
--b. Actualizati coloana orase pentru o excursie specificata: 
--- adaugati un oras nou în lista, ce va fi ultimul vizitat în excursia respectiva;
--- adaugati un oras nou în lista, ce va fi al doilea oras vizitat în excursia respectiva;
--- inversati ordinea de vizitare a doua dintre orase al caror nume este specificat;
--- eliminati din lista un oras al carui nume este specificat.
--c. Pentru o excursie al carui cod este dat, afisati numarul de orase vizitate, respectiv numele oraselor.
--d. Pentru fiecare excursie afisati lista oraselor vizitate.
--e. Anulati excursiile cu cele mai putine orase vizitate.

CREATE OR REPLACE TYPE tip_orase_rsa AS VARRAY(10) OF VARCHAR2(50);
/
CREATE TABLE excursie_rsa (cod_excursie NUMBER(4) PRIMARY KEY,
                           denumire VARCHAR2(20),
                           orase tip_orase_rsa,
                           status VARCHAR2(20));
--a)
BEGIN 
FOR i in 1..5 LOOP
    INSERT INTO excursie_rsa VALUES (i, 'necunoscut', tip_orase_rsa('o1', 'o2', 'o3', 'o4', 'o5'), 'disponibil');
END LOOP;
END;

select * from excursie_rsa;
--b1)adaugam un oras nou, ce va fi ultimul vizitat in excursia specificata
DECLARE
excursie_specificata excursie_rsa.cod_excursie%TYPE := &cod_excursie;
oras_introdus VARCHAR2(20) := '&denumire';
orase_aux excursie_rsa.orase%TYPE;
BEGIN
    SELECT orase INTO orase_aux 
    FROM excursie_rsa 
    WHERE (cod_excursie = excursie_specificata);
orase_aux.extend();
orase_aux(orase_aux.last) := oras_introdus;

UPDATE excursie_rsa 
SET orase = orase_aux
WHERE (cod_excursie = excursie_specificata);
END;

--b2)adaugam un oras nou, ce va fi al doilea vizitat in excursie 
DECLARE
    excursie_specificata excursie_rsa.cod_excursie%TYPE := &cod_excursie;
    oras_introdus VARCHAR2(20) := '&denumire';
    orase_aux excursie_rsa.orase%TYPE;
BEGIN
    SELECT orase
    INTO orase_aux
    FROM excursie_rsa
    WHERE cod_excursie = excursie_specificata;
    
    orase_aux.extend();
    
    FOR i IN REVERSE orase_aux.FIRST+1..orase_aux.LAST LOOP
        orase_aux(i) := orase_aux(i-1);
    END LOOP;
    
    orase_aux(2) := oras_introdus;
    
    UPDATE excursie_rsa
    SET orase = orase_aux
    WHERE (cod_excursie = excursie_specificata);
END;
select * from excursie_rsa;
--b3)inversam ordinea de vizitare a doua dintre orase al caror nume este specificat
DECLARE
    excursie_specificata excursie_rsa.cod_excursie%TYPE := &cod_excursie;
    oras_introdus_1 VARCHAR2(20) := '&denumire1';
    oras_introdus_2 VARCHAR2(20) := '&denumire2';
    orase_aux excursie_rsa.orase%TYPE;
BEGIN
    SELECT orase
    INTO orase_aux
    FROM excursie_rsa
    WHERE cod_excursie = excursie_specificata;
    
    FOR i IN orase_aux.FIRST..orase_aux.LAST LOOP
        IF orase_aux(i) = oras_introdus_1 THEN
            orase_aux(i) := oras_introdus_2;
        ELSIF orase_aux(i) = oras_introdus_2 THEN
            orase_aux(i) := oras_introdus_1;
        END IF;
    END LOOP;
    
    UPDATE excursie_rsa
    SET orase = orase_aux
    WHERE (cod_excursie = excursie_specificata);
END;

--b4)eliminam din lista un oras al carui nume este specificat
DECLARE
    excursie_specificata excursie_rsa.cod_excursie%TYPE := &cod_excursie;
    oras_introdus VARCHAR2(20) := '&denumire';
    orase_aux excursie_rsa.orase%TYPE;
    orase_nou excursie_rsa.orase%TYPE := tip_orase_rsa();
BEGIN
    SELECT orase
    INTO orase_aux
    FROM excursie_rsa
    WHERE cod_excursie = excursie_specificata;
    
    FOR i IN orase_aux.FIRST..orase_aux.LAST LOOP
        IF orase_aux(i) <> oras_introdus THEN
            orase_nou.EXTEND;
            orase_nou(orase_nou.LAST) := orase_aux(i);
        END IF;
    END LOOP;
    
    UPDATE excursie_rsa
    SET orase = orase_nou
    WHERE (cod_excursie = excursie_specificata);
END;

select * from excursie_rsa;

--c)
DECLARE
excursie_specificata excursie_rsa.cod_excursie%TYPE := &cod_excursie;
orase_aux excursie_rsa.orase%TYPE;
BEGIN
    SELECT orase INTO orase_aux 
    FROM excursie_rsa 
    WHERE (cod_excursie = excursie_specificata);

DBMS_OUTPUT.PUT_LINE('Nr orase vizitate: ' || orase_aux.count);
DBMS_OUTPUT.PUT('Nume orase vizitate: ');
FOR i IN 1..orase_aux.LAST LOOP
    DBMS_OUTPUT.PUT(orase_aux(i) || '  ');
END LOOP;
DBMS_OUTPUT.NEW_LINE;
END;

--d)
DECLARE 
    TYPE excursii IS VARRAY(10) OF excursie_rsa.cod_excursie%TYPE;
    lista_excursii excursii;
    orase_nou excursie_rsa.orase%TYPE;
BEGIN
    SELECT cod_excursie BULK COLLECT INTO lista_excursii 
    FROM excursie_rsa;
    
    FOR i IN 1..lista_excursii.COUNT LOOP
        SELECT orase INTO orase_nou
        FROM excursie_rsa
        WHERE cod_excursie = lista_excursii(i);
        
        DBMS_OUTPUT.PUT('Orasele din excursia ' || lista_excursii(i) || ': ');
        
        FOR i IN 1..orase_nou.COUNT LOOP
            DBMS_OUTPUT.PUT(orase_nou(i) || ' ');
        END LOOP;      
    DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;

--e)anulam excursiile cu cele mai putine orase vizitate
DECLARE
    min_orase INTEGER :=999999;
    orase_nou excursie_rsa.orase%TYPE;
    TYPE excursii IS VARRAY(10) OF excursie_rsa.cod_excursie%TYPE;
    lista_excursii excursii;
BEGIN
    SELECT cod_excursie BULK COLLECT INTO lista_excursii 
    FROM excursie_rsa;
    
    FOR i IN 1..lista_excursii.COUNT LOOP
        SELECT orase INTO orase_nou
        FROM excursie_rsa
        WHERE cod_excursie = lista_excursii(i);
    
        IF orase_nou.COUNT() < min_orase THEN
            min_orase := orase_nou.COUNT();
        END IF;
    END LOOP;
    
    FOR i IN 1..lista_excursii.COUNT LOOP
        SELECT orase INTO orase_nou
        FROM excursie_rsa
        WHERE cod_excursie = lista_excursii(i);
    
        IF orase_nou.COUNT() = min_orase THEN
                    UPDATE excursie_rsa
                    SET status = 'anulata'
                    WHERE cod_excursie = i;   
    DBMS_OUTPUT.PUT_LINE('Excursia anulata este: '|| i);
        END IF;
    END LOOP;
END;

select * from excursie_rsa;

--ex3)Rezolvati problema anterioara folosind un alt tip de colectie studiat
--folosim tipul de colectie numit TABLOU IMBRICAT(NESTED TABLE)
--nu folosim TABLOU INDEXAT deoarece permit inserarea de elemente cu chei arbitrare,
--adica nu intr-o ordine prestabilita, asa cum se cere in problema

CREATE OR REPLACE TYPE tip_orase_rsaa IS TABLE OF VARCHAR2(50);
/
CREATE TABLE excursie_rsaa (cod_excursiee NUMBER(4) PRIMARY KEY,
                            denumiree VARCHAR2(20),
                            statuss VARCHAR2(20));
ALTER TABLE excursie_rsaa
ADD (orasee tip_orase_rsaa)
NESTED TABLE orasee STORE AS tab_imbricat_orase_rsa;

--a)
BEGIN 
FOR i in 1..5 LOOP
    INSERT INTO excursie_rsaa VALUES (i, 'necunoscut', 'disponibil', tip_orase_rsaa('o1','o2','o3','o4','o5'));
END LOOP;
END;

--b1)adaugam un oras nou, ce va fi ultimul vizitat in excursia specificata
DECLARE
    excursiee_specificata excursie_rsaa.cod_excursiee%TYPE := &cod_excursiee;
    oras_introdus VARCHAR2(20) := '&denumire';
    orasee_aux excursie_rsaa.orasee%TYPE;
BEGIN
    SELECT orasee INTO orasee_aux 
    FROM excursie_rsaa
    WHERE (cod_excursiee = excursiee_specificata);
orasee_aux.extend();
orasee_aux(orasee_aux.last) := oras_introdus;

UPDATE excursie_rsaa 
SET orasee = orasee_aux
WHERE (cod_excursiee = excursiee_specificata);
END;

--b2)adaugam un oras nou, ce va fi al doilea vizitat in excursie 
DECLARE
    excursiee_specificata excursie_rsaa.cod_excursiee%TYPE := &cod_excursiee;
    oras_introdus VARCHAR2(20) := '&denumire';
    orasee_aux excursie_rsaa.orasee%TYPE;
BEGIN
    SELECT orasee
    INTO orasee_aux
    FROM excursie_rsaa
    WHERE cod_excursiee = excursiee_specificata;
    
    orasee_aux.extend();
    
    FOR i IN REVERSE orasee_aux.FIRST+1..orasee_aux.LAST LOOP
        orasee_aux(i) := orasee_aux(i-1);
    END LOOP;
    
    orasee_aux(2) := oras_introdus;
    
    UPDATE excursie_rsaa
    SET orasee = orasee_aux
    WHERE (cod_excursiee = excursiee_specificata);
END;

--b3)inversam ordinea de vizitare a doua dintre orase al caror nume este specificat
DECLARE
    excursiee_specificata excursie_rsaa.cod_excursiee%TYPE := &cod_excursiee;
    oras_introdus_1 VARCHAR2(20) := '&denumire1';
    oras_introdus_2 VARCHAR2(20) := '&denumire2';
    orasee_aux excursie_rsaa.orasee%TYPE;
BEGIN
    SELECT orasee
    INTO orasee_aux
    FROM excursie_rsaa
    WHERE cod_excursiee = excursiee_specificata;
    
    FOR i IN orasee_aux.FIRST..orasee_aux.LAST LOOP
        IF orasee_aux(i) = oras_introdus_1 THEN
            orasee_aux(i) := oras_introdus_2;
        ELSIF orasee_aux(i) = oras_introdus_2 THEN
            orasee_aux(i) := oras_introdus_1;
        END IF;
    END LOOP;
    
    UPDATE excursie_rsaa
    SET orasee = orasee_aux
    WHERE (cod_excursiee = excursiee_specificata);
END;

--b4)eliminam din lista un oras al carui nume este specificat
DECLARE
    excursiee_specificata excursie_rsaa.cod_excursiee%TYPE := &cod_excursiee;
    oras_introdus VARCHAR2(20) := '&denumire';
    orasee_aux excursie_rsaa.orasee%TYPE;
    orasee_nou excursie_rsaa.orasee%TYPE := tip_orase_rsaa();
BEGIN
    SELECT orasee
    INTO orasee_aux
    FROM excursie_rsaa
    WHERE cod_excursiee = excursiee_specificata;
    
    FOR i IN orasee_aux.FIRST..orasee_aux.LAST LOOP
        IF orasee_aux(i) <> oras_introdus THEN
            orasee_nou.EXTEND;
            orasee_nou(orasee_nou.LAST) := orasee_aux(i);
        END IF;
    END LOOP;
    
    UPDATE excursie_rsaa
    SET orasee = orasee_nou
    WHERE (cod_excursiee = excursiee_specificata);
END;

--c)
DECLARE
excursiee_specificata excursie_rsaa.cod_excursiee%TYPE := &cod_excursiee;
orasee_aux excursie_rsaa.orasee%TYPE;
BEGIN
    SELECT orasee INTO orasee_aux 
    FROM excursie_rsaa
    WHERE (cod_excursiee = excursiee_specificata);

DBMS_OUTPUT.PUT_LINE('Numar orase vizitate: ' || orasee_aux.count);
DBMS_OUTPUT.PUT('Nume orase vizitate: ');
FOR i IN 1..orasee_aux.LAST LOOP
    DBMS_OUTPUT.PUT(orasee_aux(i) || '  ');
END LOOP;
DBMS_OUTPUT.NEW_LINE;
END;

--d)
DECLARE 
    TYPE excursiii IS VARRAY(10) OF excursie_rsaa.cod_excursiee%TYPE;
    lista_excursiii excursiii;
    orasee_nou excursie_rsaa.orasee%TYPE;
BEGIN
    SELECT cod_excursiee BULK COLLECT INTO lista_excursiii 
    FROM excursie_rsaa;
    
    FOR i IN 1..lista_excursiii.COUNT LOOP
        SELECT orasee INTO orasee_nou
        FROM excursie_rsaa
        WHERE cod_excursiee = lista_excursiii(i);
        
        DBMS_OUTPUT.PUT('Orasele din excursia ' || lista_excursiii(i) || ': ');
        
        FOR i IN 1..orasee_nou.COUNT LOOP
            DBMS_OUTPUT.PUT(orasee_nou(i) || ' ');
        END LOOP;      
    DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;

--e)anulam excursiile cu cele mai putine orase vizitate
DECLARE
    min_orasee INTEGER :=999999;
    orasee_nou excursie_rsaa.orasee%TYPE;
    TYPE excursiii IS VARRAY(10) OF excursie_rsaa.cod_excursiee%TYPE;
    lista_excursiii excursiii;
BEGIN
    SELECT cod_excursiee BULK COLLECT INTO lista_excursiii 
    FROM excursie_rsaa;
    
    FOR i IN 1..lista_excursiii.COUNT LOOP
        SELECT orasee INTO orasee_nou
        FROM excursie_rsaa
        WHERE cod_excursiee = lista_excursiii(i);
    
        IF orasee_nou.COUNT() < min_orasee THEN
            min_orasee := orasee_nou.COUNT();
        END IF;
    END LOOP;
    
    FOR i IN 1..lista_excursiii.COUNT LOOP
        SELECT orasee INTO orasee_nou
        FROM excursie_rsaa
        WHERE cod_excursiee = lista_excursiii(i);
    
        IF orasee_nou.COUNT() = min_orasee THEN
                    UPDATE excursie_rsaa
                    SET statuss = 'anulata'
                    WHERE cod_excursiee = i;   
    DBMS_OUTPUT.PUT_LINE('Excursia anulata este: '|| i);
        END IF;
    END LOOP;
END;


SELECT * FROM excursie_rsaa;



    
    