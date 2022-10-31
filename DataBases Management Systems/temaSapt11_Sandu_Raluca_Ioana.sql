--TEMA CURS SGBD SAPTAMANA 11
--Realizata de: Sandu Raluca-Ioana
--Grupa 242

--1) trigger compus

--Adaug coloana mentor_id, pe care il voi face cheie straina si de care ma voi folosi in
--rezolvarea cerintei

CREATE TABLE mmbr_copy_sri AS SELECT * FROM member;
SELECT * FROM mmbr_copy_sri;

ALTER TABLE mmbr_copy_sri ADD mentor_id NUMBER(10,0);

ALTER TABLE mmbr_copy_sri 
ADD constraint pkey_mmbr PRIMARY KEY(member_id);

ALTER TABLE mmbr_copy_sri
ADD constraint fkey_librarian FOREIGN KEY (mentor_id) REFERENCES mmbr_copy_sri(member_id);


UPDATE mmbr_copy_sri
SET mentor_id = 101
WHERE member_id IN (102, 103);

UPDATE mmbr_copy_sri
SET mentor_id = 103
WHERE member_id = 104;


UPDATE mmbr_copy_sri
SET mentor_id = 104
WHERE member_id IN (105, 106, 107, 108);

UPDATE mmbr_copy_sri
SET mentor_id = 102
WHERE member_id = 109;

--Incercati sa modificati data la care un membru si-a facut abonament pentru a putea inchiria filme.
--Definiti un trigger compus care sa nu permita ca data de inscriere a unui membru sa fie mai devreme
--decat data de inscriere a mentorului sau. 

CREATE OR REPLACE TRIGGER compound_trigger_sri
    FOR UPDATE OF join_date ON mmbr_copy_sri
    COMPOUND TRIGGER
    
    TYPE lista IS RECORD(join_date DATE, member_id NUMBER);
    TYPE join_dates_mentors IS TABLE OF lista;
    t join_dates_mentors;
    
    BEFORE STATEMENT IS

BEGIN 
    SELECT m.join_date, m.member_id BULK COLLECT INTO t
    FROM mmbr_copy_sri a JOIN mmbr_copy_sri m ON a.mentor_id = m.member_id
    GROUP BY m.join_date, m.member_id;
    
    END BEFORE STATEMENT;
    
    AFTER EACH ROW IS 
    
BEGIN
    FOR i in 1..t.count() LOOP 
        IF :NEW.mentor_id = t(i).member_id AND :NEW.join_date < t(i).join_date THEN
            RAISE_APPLICATION_ERROR(-20000, 'Data inregistrarii membrului este mai veche data inregistrarii mentorului sau!');
        END IF;
    END LOOP;
    NULL;
    
    END AFTER EACH ROW;

END compound_trigger_sri;
/

select * from mmbr_copy_sri;

UPDATE mmbr_copy_sri
SET join_date = '03-JUN-70' --se declanseaza trigger-ul, deoarece membrul cu id ul 103
WHERE member_id = 103;      --il are ca mentor pe cel cu id-ul 101, iar data de inregistrare a lui 101 este 3 martie 1990



--daca incercam o data aflata dupa 3 martie 1990, update-ul se va realiza cu succes:
UPDATE mmbr_copy_sri
SET join_date = '03-JUN-01'
WHERE member_id = 103;

select * from mmbr_copy_sri;

rollback;
--2) trigger pe tabela MUTATING

CREATE OR REPLACE TRIGGER mutating_sri
    BEFORE DELETE ON title_rsa
    FOR EACH ROW
DECLARE
    v_categorie VARCHAR2(50);
BEGIN 
    SELECT category INTO v_categorie
    FROM title_rsa
    WHERE title_id = :OLD.title_id;
END;
/

DELETE FROM title_rsa WHERE title_id = 92; --Am pus trigger-ul pe tabela title_rsa, iar informatiile
                                           --le iau tot din title_rsa, deci delete-ul acesta vede
                                           --tabela ca fiind MUTATING.
                                           
--Daca vreau sa sterg ceva ce nu exista in tabel, nu primesc eroare, ci se va afisa in script output '0 rows deleted'
DELETE FROM title_rsa WHERE title_id = 500;

--am mai facut un trigger pe tabela MUTATING si am rezolvat si problema de tabel MUTATING

SELECT * FROM RENTAL_RSA;


--Definiti un trigger care sa nu permita unui membru sa faca mai mult de 5 inchirieri de filme.

CREATE OR REPLACE TRIGGER check_max_inchirieri
BEFORE INSERT OR UPDATE OF member_id ON rental_rsa
FOR EACH ROW
DECLARE
    nr_inchirieri NUMBER(1);
BEGIN
    SELECT count(*) INTO nr_inchirieri
    FROM rental_rsa
    WHERE member_id = :NEW.member_id;
    
    IF nr_inchirieri = 5 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Acest membru a imprumutat deja prea multe filme!');
    END IF;
END;

--membrul 101 are deja numarul maxim de inchirieri
INSERT INTO rental_rsa VALUES(sysdate, 2, 101, 93, null, null);

--functioneaza, deoarece utilizatorul cu id-ul 102 nu are numarul maxim de postari
INSERT INTO rental_rsa VALUES(sysdate, 2, 102, 93, null, null);
rollback;

--comenzi ce genereaza eroare mutating
INSERT INTO rental_rsa
SELECT sysdate, 2, 101, 93, null, null
FROM DUAL;

--solutie pentru rezolvarea erorii de tabel mutating

CREATE OR REPLACE PACKAGE pachet_check_max_inchirieri
AS
    TYPE tip_rec IS RECORD
    (cod rental_rsa.member_id%TYPE,
     nr_inchirieri NUMBER(1));
    
    TYPE tip_ind IS TABLE OF tip_rec INDEX BY PLS_INTEGER;
    t tip_ind;
    contor NUMBER(2) :=0;
END;
/
CREATE OR REPLACE TRIGGER check_max_inchirieri_t_comanda
    BEFORE INSERT OR UPDATE OF member_id ON rental_rsa
BEGIN
    pachet_check_max_inchirieri.contor := 0;
    
    SELECT member_id, count(*) BULK COLLECT INTO pachet_check_max_inchirieri.t
    FROM  rental_rsa
    GROUP BY member_id;
END;
/
CREATE OR REPLACE TRIGGER check_max_inchirieri_t_linie
    BEFORE INSERT OR UPDATE OF member_id ON rental_rsa
    FOR EACH ROW
BEGIN
    FOR i in 1..pachet_check_max_inchirieri.t.LAST LOOP
        IF pachet_check_max_inchirieri.t(i).cod = :NEW.member_id
            AND pachet_check_max_inchirieri.t(i).nr_inchirieri + pachet_check_max_inchirieri.contor = 5
        THEN
            RAISE_APPLICATION_ERROR(-20000, 'Membrul cu id-ul ' || :NEW.member_id || ' depaseste numarul maxim de inchirieri!');
        END IF;
    END LOOP;
    pachet_check_max_inchirieri.contor := pachet_check_max_inchirieri.contor + 1;
END;
/

--comenzi ce generau eroare mutating inainte, acum declanseaza triggerul
INSERT INTO rental_rsa
SELECT sysdate, 2, 101, 93, null, null
FROM DUAL;
