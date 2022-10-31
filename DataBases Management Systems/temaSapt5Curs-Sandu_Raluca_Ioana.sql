--Tema saptamana 5 curs SGBD
--Realizata de: Sandu Raluca-Ioana
--Grupa: 242

--ex.
--Mentineti intr-o colectie codurile primilor 8 angajati in ordine alfabetica(dupa numele de familie)
--care lucreaza in unul din departamentele 50 si 80. Pentru acesti angajati, schimbati departamentul,
--setand ca acestia sa lucreze in departamentul 250. Afisati departamentul vechi, respectiv departamentul nou. 
--Anulati modificarile. 

--cu tablou indexat 
DECLARE 
    TYPE tab_indexat IS TABLE OF emp_rsa%ROWTYPE INDEX BY BINARY_INTEGER;
    t tab_indexat;
    dep_vechi_rsa NUMBER;
    dep_nou_rsa NUMBER;
    timp_executie_start NUMBER := DBMS_UTILITY.GET_TIME;
BEGIN
--introduc in colectie angajatii inainte de a le schimba departamentul  
    DBMS_OUTPUT.PUT_LINE('Varianta cu tablou indexat: ');
    SELECT *
    BULK COLLECT INTO t
    FROM (SELECT *
          FROM emp_rsa 
          WHERE department_id IN (50, 80)
          ORDER BY last_name)
    WHERE ROWNUM <=8;
    
    FOR i IN t.first..t.last LOOP     
        IF t.exists(i) THEN 
        
            SELECT department_id INTO dep_vechi_rsa
            FROM emp_rsa 
            WHERE employee_id = t(i).employee_id;
        
            UPDATE emp_rsa 
            SET department_id = 250 
            WHERE employee_id = t(i).employee_id;
        
            SELECT department_id INTO dep_nou_rsa
            FROM emp_rsa 
            WHERE employee_id = t(i).employee_id;
        
            DBMS_OUTPUT.PUT_LINE('Cod angajat: ' || t(i).employee_id || 
                                 ' | Nume de familie: ' || t(i).last_name ||
                                 ' | Departament vechi: ' || dep_vechi_rsa ||
                                 ' | Departament nou: ' || dep_nou_rsa);
        END IF;
    END LOOP;
DBMS_OUTPUT.PUT_LINE('Timp executie: ' || round((DBMS_UTILITY.GET_TIME - timp_executie_start )/100, 4)||' secunde');
ROLLBACK;
END;        
 
--cu vector:
DECLARE
    TYPE raluca IS VARRAY(10) OF emp_rsa.employee_id%TYPE;
    coduri_rsa raluca;
    dep_vechi_rsa NUMBER;
    dep_nou_rsa NUMBER;
    last_name_rsa VARCHAR2(30);
    timp_executie_start NUMBER := DBMS_UTILITY.GET_TIME;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Varianta cu vector: '); 
    SELECT employee_id BULK COLLECT INTO coduri_rsa
    FROM (SELECT employee_id, last_name, department_id
          FROM employees
          WHERE department_id IN (50, 80)
          ORDER BY last_name)
    WHERE ROWNUM <= 8;

    FOR i IN coduri_rsa.first..coduri_rsa.last LOOP
        IF coduri_rsa.exists(i) THEN 
        
        SELECT department_id INTO dep_vechi_rsa
        FROM emp_rsa 
        WHERE employee_id = coduri_rsa(i);
        
        UPDATE emp_rsa 
        SET department_id = 250 
        WHERE employee_id = coduri_rsa(i);
        
        SELECT department_id INTO dep_nou_rsa
        FROM emp_rsa 
        WHERE employee_id = coduri_rsa(i);
        
        SELECT last_name INTO last_name_rsa
        FROM emp_rsa 
        WHERE employee_id = coduri_rsa(i);
        
        DBMS_OUTPUT.PUT_LINE('Cod angajat: ' || coduri_rsa(i) || 
                             ' | Nume de familie: ' || last_name_rsa ||
                             ' | Departament vechi: ' || dep_vechi_rsa ||
                             ' | Departament nou: ' || dep_nou_rsa);
        END IF;
    END LOOP;
DBMS_OUTPUT.PUT_LINE('Timp executie: ' || round((DBMS_UTILITY.GET_TIME - timp_executie_start )/100, 2)||' secunde');
ROLLBACK;
END;
        
--cu tablou imbricat
DECLARE
    TYPE raluca_imbricat IS TABLE OF emp_rsa.employee_id%TYPE;
    tt raluca_imbricat := raluca_imbricat();
    dep_vechi_rsa NUMBER;
    dep_nou_rsa NUMBER;
    last_name_rsa VARCHAR2(30);
    timp_executie_start NUMBER := DBMS_UTILITY.GET_TIME;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Varianta cu tablou imbricat: ');
    FOR i in 1..8 LOOP
        tt.extend;
        tt(i):=i;
    END LOOP;
    SELECT employee_id BULK COLLECT INTO tt
    FROM (SELECT employee_id, last_name, department_id
          FROM employees
          WHERE department_id IN (50, 80)
          ORDER BY last_name)
    WHERE ROWNUM <= 8;

    FOR i IN tt.first..tt.last LOOP
        IF tt.exists(i) THEN 
        
        SELECT department_id INTO dep_vechi_rsa
        FROM emp_rsa 
        WHERE employee_id = tt(i);
        
        UPDATE emp_rsa 
        SET department_id = 250 
        WHERE employee_id = tt(i);
        
        SELECT department_id INTO dep_nou_rsa
        FROM emp_rsa 
        WHERE employee_id = tt(i);
        
        SELECT last_name INTO last_name_rsa
        FROM emp_rsa 
        WHERE employee_id = tt(i);
        
        DBMS_OUTPUT.PUT_LINE('Cod angajat: ' || tt(i) || 
                             ' | Nume de familie: ' || last_name_rsa ||
                             ' | Departament vechi: ' || dep_vechi_rsa ||
                             ' | Departament nou: ' || dep_nou_rsa);
        END IF;
    END LOOP;
DBMS_OUTPUT.PUT_LINE('Timp executie: ' || round((DBMS_UTILITY.GET_TIME - timp_executie_start )/100, 2)||' secunde');
ROLLBACK;
END;

select * from emp_rsa;

--Uitandu-ne in SQL History, la Duration, observam ca la prima rulare obtinem urmatoarele valori:
--pentru TABLOUL INDEXAT : 0.005 secunde
--pentru VECTOR : 0.005 secunde
--pentru TABLOUL IMBRICAT : 0.017 secunde

--La a doua rulare, obtinem urmatoarele valori(in aceasta ordine a rularii):
--pentru TABLOUL IMBRICAT : 0.010 secunde
--pentru VECTOR : 0.012 secunde
--pentru TABLOUL INDEXAT: 0.006 secunde

--La a treia rulare, obtinem urmatoarele valori(in aceasta ordine a rularii):
--pentru VECTOR : 0.018 secunde
--pentru TABLOU IMBRICAT : 0.009 secunde
--pentru TABLOUL INDEXAT : 0.004

--Observam ca de fiecare data tabloul indexat a fost cel mai rapid, deci este cel mai bun
--din punct de vedere al optimizarii.

--Totusi, trebuie sa tinem cont de caracteristicile acestor tipuri de colectii atunci cand rezolvam
--un exercitiu. 

--Tablourile indexate sunt reprezentate printr-o multime de valori de tip cheie-valoare, fiecare 
--cheie fiind unica si fiind utilizata pentru a accesa un anumit element. Dimensiunea este dinamica, 
--deci acest tip de colectie este optim atunci cand nu ni se da dimensiunea. Mai mult, acesta este
--folosit mai ales atunci cand vrem sa stocam date temporare. De aceea, nu se poate utiliza in SQL.

--Asemanatoare cu tablourile indexate sunt tablourile imbricate, care sunt asemanatoare unor tablouri
--cu o singura coloana. La fel ca in cazurile tablourilor indexate, si dimensiunea acestora
--creste dinamic, insa pentru a adauga un element nou, trebuie sa ii cream spatiul necesar prin comanda
--EXTEND. In mod similar cu vectorii, permit accesarea elementelor in functie de indecsi. Trebuie sa fie
--initializate(prin constructor) si extinse pentru a putea stoca valori.

--Vectorii se folosesc mai ales atunci cand stim de la inceput dimesniunea maxima. Acestia nu pot
--depasi dimensiunea data la declarare. Acestia sunt optimi atunci cand ordinea elementelor este 
--importanta, iar numarul de elemente MANY dintr-o relatie 1 TO MANY este cunoscut. 