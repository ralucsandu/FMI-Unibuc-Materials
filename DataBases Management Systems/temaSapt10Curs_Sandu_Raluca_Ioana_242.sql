--TEMA SAPTAMANA 10 CURS SGBD
--Realizata de: Sandu Raluca-Ioana, grupa 242

--1)
--trigger INSTEAD OF

create table title_sri as select * from title;   --copie pt title
create table title_copy_sri as select * from title_copy; --copie pt title_copy

--Creati doua tabele, film_details si film_copy_details astfel:
--tabelul film_details are coloanele cod_film (cheie primara), denumire, categorie
--tabelul film_copy_details are coloanele cod_copie, cod_film(cele doua formeaza impreuna o cheie primara compusa), status

CREATE TABLE film_details_sri (
    cod_film NUMBER(10,0) PRIMARY KEY,
    denumire VARCHAR2(60 BYTE),
    categorie VARCHAR2(20 BYTE)
    );
    
CREATE TABLE film_cp_details_sri (
    cod_copie NUMBER(10,0),
    cod_film NUMBER (10,0),
    CONSTRAINT film_cp_details_pk PRIMARY KEY (cod_copie, cod_film),
    status VARCHAR2(15 BYTE)
    );
    
--Populati cele doua tabele cu informatiile existente in schema Video

INSERT INTO film_details_sri
     SELECT title_id, title, category
     FROM title_sri;

INSERT INTO film_cp_details_sri 
    SELECT copy_id, title_id, status
    FROM title_copy_sri;

--Creati vizualizarea view_info care sa contina informatiile despre fiecare film si copiile existente pentru acestea
--Folositi-va de cele doua tabele create anterior.

CREATE OR REPLACE VIEW view_info_rsa AS
SELECT a.cod_film, a.denumire, a.categorie, b.cod_copie, b.status
FROM film_details_sri a, film_cp_details_sri b
WHERE a.cod_film = b.cod_film;

--Definiti un trigger prin care actualizarile ce au loc asupra vizualizarii sa se propage automat
--in tabelele de baza, stiind ca au loc urmatoarele actualizari: 
--    -se elimina un film, 
--    -se modifica statusul unui exemplar dintr un film

--Verificati buna functionare a triggerului!

--select * from film_details_sri;
--select * from film_cp_details_sri;
--select * from view_info_rsa;

CREATE OR REPLACE TRIGGER trig_sri
INSTEAD OF DELETE OR UPDATE ON view_info_rsa
FOR EACH ROW 
BEGIN
    IF DELETING THEN 
--stergerea unui film din vizualizare determina stegerea din film_details_sri
--si din film_cp_details_sri
        DELETE FROM film_details_sri 
        WHERE cod_film =:OLD.cod_film;
        
        DELETE FROM film_cp_details_sri
        WHERE cod_film =:OLD.cod_film;
        
    ELSIF UPDATING ('status') THEN
--modificarea statusului unui exemplar de film din vizualizare determina
--modificarea statusului in tabelul film_cp_details_sri

        UPDATE film_cp_details_sri
        SET status =:NEW.status
        WHERE cod_copie =:OLD.cod_copie;
        
    END IF;
END;
/

--verificare trigger

--incercam sa eliminam filmul cu codul 92. Functioneaza :) , rezultatele fiind vizibile nu doar in vizualizare, ci si in cele doua tabele
DELETE FROM view_info_rsa 
WHERE cod_film = 92;

SELECT * FROM  film_details_sri;
SELECT * FROM  film_cp_details_sri;     
SELECT * FROM view_info_rsa;

--incercam sa actualizam statusul pentru exemplarul 2 din filmul cu id-ul 95
--adica il facem din RENTED, AVAILABLE

UPDATE view_info_rsa --functioneaza :)  , rezultatele fiind vizibile nu doar in vizualizare, ci si in cele doua tabele
SET status = 'AVAILABLE'
WHERE cod_film = 95 and cod_copie = 2;

SELECT * FROM view_info_rsa;
SELECT * FROM  film_cp_details_sri; 

ROLLBACK;
DROP TRIGGER trig_sri;

--2)
--trigger pe TABLOU IMBRICAT

--Creati un tabel auxiliar pentru tabelul membru, in care sa retineti codul, 
--numele si prenumele primilor 5 angajati din baza de date. Adaugati in acest tabel
--un camp nou, in care sa se retina genurile de filme preferate ale fiecarui membru. 

CREATE TABLE membru_aux_sri AS
    SELECT member_id, last_name, first_name
    FROM member
    WHERE ROWNUM <=5;

CREATE OR REPLACE TYPE preferinte_membru IS TABLE OF VARCHAR2(30);

ALTER TABLE membru_aux_sri
ADD (genuri_preferate preferinte_membru)
NESTED TABLE genuri_preferate STORE AS tab_imbr_genuri_rsa;

UPDATE membru_aux_sri
SET genuri_preferate = preferinte_membru('gen1', 'gen2')
WHERE member_id = 101;

UPDATE membru_aux_sri
SET genuri_preferate = preferinte_membru('gen2', 'gen4')
WHERE member_id = 103;

UPDATE membru_aux_sri
SET genuri_preferate = preferinte_membru('gen1', 'gen4', 'gen5')
WHERE member_id = 102;

UPDATE membru_aux_sri
SET genuri_preferate = preferinte_membru('gen2')
WHERE member_id = 104;

UPDATE membru_aux_sri
SET genuri_preferate = preferinte_membru('gen3')
WHERE member_id = 105;

select * from membru_aux_sri;

--Definiti un trigger care sa blocheze stergerea unui membru al carui cod este dat
--de la tastatura, stiind ca acesta poate fi sters doar daca are mai mult de 2 genuri de filme preferate. 

CREATE OR REPLACE TRIGGER sterge_gen_pref_sri
    BEFORE DELETE ON membru_aux_sri
DECLARE
    membru_specificat membru_aux_sri.member_id%TYPE := &member_id;
    nr_genuri_membru NUMBER;
    genuri_preferate_aux membru_aux_sri.genuri_preferate%TYPE;
BEGIN 
    SELECT genuri_preferate INTO genuri_preferate_aux
    FROM membru_aux_sri
    WHERE (member_id = membru_specificat);

    IF genuri_preferate_aux.count <= 2 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Membrul nu poate fi sters deoarece are mai putin de 2 genuri de filme preferate!');
    END IF;
END;
/
DELETE membru_aux_sri  --desi apelam triggerul pentru membrul cu id-ul 102, acesta nu se declanseaza, deoarece
WHERE member_id = 102; --acest membru are 3 genuri preferate, deci respecta conditia impusa. 
                       --Stergerea se realizeaza cu succes!

DELETE membru_aux_sri
WHERE member_id = 105; --se declanseaza triggerul deoarece membrul cu id-ul 105 are doar un singur gen de film preferat 
                       -- => primim mesajul de eroare

