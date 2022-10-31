--Tema curs saptamana 8 SGBD
--Realizata de : Sandu Raluca-Ioana
--Grupa 242

--Ce tipuri de proceduri pot fi transformate în functii? 

--Raspuns: In principiu, putem transforma in functii procedurile care vor intoarce un rezultat. 
--De exemplu, daca avem o tabela MEMBRU in care tinem, pe langa alte atribute, numele membrului si 
--data nasterii, putem sa ii aflam data nasterii atat folosind proceduri, cat si folosind functii. 

--Un exemplu de problema este urmatorul:
--Folosindu-va de schema VIDEO, definiti un subprogram prin care sa obtineti data de lansare si rating-ul
--unui film al carui titlu este dat. Tratati toate exceptiile ce pot aparea si testati subprogramul
--pe toate cazurile. Rezolvati exercitiul folosind atat o functie stocata, cat si o procedura stocata.

SELECT * FROM TITLE_RSA;

--functie stocata
CREATE OR REPLACE FUNCTION f_rsa(titlu_film title_rsa.title%TYPE DEFAULT 'The Glob')
    RETURN DATE IS data_lansare title_rsa.release_date%TYPE;
BEGIN
    SELECT release_date INTO data_lansare
    FROM title_rsa
    WHERE title = titlu_film;
    RETURN data_lansare;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu a fost gasit niciun film cu titlul dat!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Au fost gasite mai multe filme cu titlul dat!');
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare!');
END f_rsa;  
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('Filmul a fost lansat in data de ' || f_rsa('Soda Gang'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Am obtinut o eroare '||SQLCODE|| ' cu mesajul ' || SQLERRM);
END;
/


--fac un INSERT pentru a verifica exceptia de TOO_MANY_ROWS
INSERT INTO title_rsa VALUES(99, 'The Glob', 'abcd', 'NR', 'SCIFI',null);


--procedura stocata 
CREATE OR REPLACE PROCEDURE p_rsa(titlu_film title_rsa.title%TYPE DEFAULT 'The Glob')
    IS data_lansare title_rsa.release_date%TYPE;
BEGIN
    SELECT release_date INTO data_lansare
    FROM title_rsa
    WHERE title = titlu_film;
    DBMS_OUTPUT.PUT_LINE('Filmul a fost lansat in data de '|| data_lansare);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000,'Nu a fost gasit niciun film cu titlul dat!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Au fost gasite mai multe filme cu titlul dat!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END p_rsa;
/
BEGIN
    p_rsa('Soda Gang');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Am obtinut o eroare '||SQLCODE|| ' cu mesajul ' || SQLERRM);
END;
/

--Comparatii intre FUNCTII si PROCEDURI: 

    -->O functie poate fi invocata in comanda SELECT deoarece ea returneaza o valoare, in timp ce 
    --in cazul procedurii(deoarece ea nu returneaza neaparat ceva) nu putem avea, 
    --de pilda, SELECT procedura(lista_parametri) FROM dual;
    
    -->O functie foloseste RETURN pentru a returna o valoare, in timp ce o procedura foloseste 
    --un parametru de iesire(OUT);
    
    -->O functie returneaza obligatoriu ceva, o procedura nu este obligatoriu sa returneze ceva;
    
    -->O functie poate sa fie optimizata prin cuvantul cheie DETERMINISTIC, lucru ce nu e valabil
    --si in cazul procedurii;
    
    -->In cazul unei functii, RETURN genereaza iesirea din functie si returnarea unei valori, 
    --in timp ce in cazul unei proceduri RETURN genereaza doar iesirea din procedura (de exemplu,
    --putem da return -1 atunci cand avem o exceptie si vrem sa iesim din subprogram dupa ce o gasim);
    