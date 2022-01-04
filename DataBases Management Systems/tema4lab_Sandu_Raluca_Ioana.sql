--Tema 4 laborator SGBD
--Realizata de : Sandu Raluca-Ioana
--Grupa: 242

--ex3.
--Definiti un bloc anonim în care sa se determine numarul de filme (titluri) împrumutate de un 
--membru al carui nume este introdus de la tastatura. Tratati urmatoarele doua situatii: 
--nu exista nici un membru cu nume dat; exista mai multi membri cu acelasi nume.

select * from member_rsa;
select * from rental_rsa;

ACCEPT p_nume_prenume PROMPT 'Introduceti numele membrului: ';
DECLARE 
    v_numar_filme_impr NUMBER(10);
    v_numar_membri NUMBER(10);
BEGIN
    SELECT COUNT(*) INTO v_numar_membri 
    FROM member_rsa 
    WHERE UPPER(last_name || ' ' || first_name) = UPPER('&&p_nume_prenume');
    
    IF 
        v_numar_membri = 1 THEN 
        SELECT COUNT (DISTINCT title_id) INTO v_numar_filme_impr
        FROM rental_rsa JOIN member_rsa on rental_rsa.member_id = member_rsa.member_id
        WHERE UPPER(last_name || ' ' || first_name) = UPPER('&&p_nume_prenume');
        DBMS_OUTPUT.PUT_LINE ('&&p_nume_prenume'|| ' a imprumutat ' || v_numar_filme_impr || ' filme ');
    ELSIF 
        v_numar_membri = 0 THEN 
        DBMS_OUTPUT.PUT_LINE('Nu exista numele membrului introdus!');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Exista mai multi membri cu numele dat!');
    END IF;
END;

--fac inserturi pentru verificare
INSERT INTO member_rsa values (110, 'Velasquez', 'Carmen', '20 Flowers Street', 'London', '0336895571', TO_DATE('12-05-1993', 'DD-MM-YYYY'));
INSERT INTO rental_rsa values (null, 2, 110, 97, null, null);
commit;


--ex4.
--Modificati problema anterioara astfel încât sa afisati si urmatorul text:
--- Categoria 1 (a împrumutat mai mult de 75% din titlurile existente)
--- Categoria 2 (a împrumutat mai mult de 50% din titlurile existente)
--- Categoria 3 (a împrumutat mai mult de 25% din titlurile existente)
--- Categoria 4 (altfel)

ACCEPT p_nume_prenume PROMPT 'Introduceti numele membrului: ';
DECLARE 
    v_numar_filme_impr NUMBER(10) :=0;
    v_numar_titluri NUMBER(10) :=0;
    v_procent NUMBER(3) :=0;
BEGIN
    SELECT COUNT(title_id) into v_numar_titluri --numarul de filme existente in baza de date 
    FROM title;
    
    SELECT COUNT (DISTINCT title_id) INTO v_numar_filme_impr   --numarul de filme imprumutate de un anumit membru
    FROM rental_rsa JOIN member_rsa on rental_rsa.member_id = member_rsa.member_id
    WHERE UPPER(last_name || ' ' || first_name) = UPPER('&&p_nume_prenume');
    DBMS_OUTPUT.PUT_LINE ('&&p_nume_prenume'|| ' a imprumutat ' || v_numar_filme_impr || ' filme ');
    
    v_procent := (v_numar_filme_impr/v_numar_titluri)*100;
    IF v_procent > 75 THEN
        DBMS_OUTPUT.PUT_LINE('Categoria 1');
    ELSIF v_procent > 50 THEN
        DBMS_OUTPUT.PUT_LINE('Categoria 2');
    ELSIF v_procent > 25 THEN
        DBMS_OUTPUT.PUT_LINE('Categoria 3');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Categoria 4');
    END IF;
END;

--ex5.
--Creati tabelul member_*** (o copie a tabelului member). Adaugati în acest tabel coloana 
--discount, care va reprezenta procentul de reducere aplicat pentru membri, în functie de categoria 
--din care fac parte acestia:
--- 10% pentru membrii din Categoria 1 
--- 5% pentru membrii din Categoria 2
--- 3% pentru membrii din Categoria 3
--- nimic 
--Actualizati coloana discount pentru un membru al carui cod este dat de la tastatura. Afisati un 
--mesaj din care sa reiasa daca actualizarea s-a produs sau nu


ALTER TABLE member_rsa ADD CONSTRAINT PK_member_rsa PRIMARY KEY (member_id);
ALTER TABLE member_rsa ADD discount NUMBER;

DECLARE 
    v_cod_membru member_rsa.member_id%TYPE := &p_cod_membru;
    v_numar_titluri NUMBER(10);
    v_numar_filme_impr NUMBER(10);
BEGIN
    SELECT COUNT(title_id) into v_numar_titluri --numarul de filme existente
    FROM title_rsa;
    
    SELECT COUNT (DISTINCT title_id) INTO v_numar_filme_impr   --numarul de filme imprumutate de un anumit membru
    FROM rental_rsa r JOIN member_rsa m USING (member_id)
    GROUP BY member_id
    HAVING member_id = v_cod_membru;
    
    CASE 
        WHEN v_numar_filme_impr * 100 / v_numar_titluri > 75 THEN
             UPDATE member_rsa
             SET discount = 10
             WHERE member_id = v_cod_membru;
             COMMIT;
             DBMS_OUTPUT.PUT_LINE('Actualizare reusita!');
        WHEN v_numar_filme_impr * 100 / v_numar_titluri > 50 THEN
             UPDATE member_rsa
             SET discount = 5
             WHERE member_id = v_cod_membru;
             COMMIT;
             DBMS_OUTPUT.PUT_LINE('Actualizare reusita!');
        WHEN v_numar_filme_impr * 100 / v_numar_titluri > 25 THEN
             UPDATE member_rsa
             SET discount = 3
             WHERE member_id = v_cod_membru;
             COMMIT;
             DBMS_OUTPUT.PUT_LINE('Actualizare reusita!');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Nu s-a produs nicio actualizare!');
     END CASE;        
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nicio actualizare facuta!');
END;       

select * from member_rsa;