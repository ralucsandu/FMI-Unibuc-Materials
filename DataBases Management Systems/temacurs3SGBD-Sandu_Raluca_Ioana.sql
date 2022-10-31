--Tema 2 curs SGBD
--Realizata de : Sandu Raluca-Ioana
--Grupa 242

--ex1.

create table departments_copy_sri as select * from departments;
select * from departments_copy_sri;

create table employees_copy_sri as select * from employees;
select * from employees_copy_sri;

DECLARE
 v_categorie NUMBER;
 v_produse NUMBER;
 v_clasificare CHAR(1);
BEGIN
 DELETE FROM clasific_clienti WHERE id_client=209
 RETURNING id_categorie, nr_produse, clasificare 
 INTO v_categorie, v_produse, v_clasificare;
 INSERT INTO clasific_clienti 
 VALUES (209,v_categorie,v_produse,null);
 UPDATE clasific_clienti 
 SET clasificare = v_clasificare
 WHERE id_client = 209;
 COMMIT;
END;

--CAZUL IN CARE DELETE PRESUPUNE STERGEREA UNEI SINGURE LINII SAU A NICIUNEIA(caz in care valoarea nu exista in tabel)
DECLARE
    first_name_sri employees.first_name%TYPE;  
    salary_sri number := &p_salary_sri;
BEGIN 
    DELETE FROM employees_copy_sri
    WHERE employee_id IN (SELECT employee_id
                         FROM employees_copy_sri
                         WHERE salary = salary_sri)
    RETURNING first_name INTO first_name_sri;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE ('Aveti o eroare cu codul ' ||SQLCODE || '!');
        DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu salariul dat!');
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Aveti o eroare cu codul ' || SQLCODE || '!');
        DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu salariul dat!');
END;
--Sa presupunem ca citim de la tastatura valoarea pentru salariu 2200. Deoarece in tabelul
--employees_copy_sri avem mai multi angajati cu acest salariu, se va trata exceptia 
--de TOO_MANY_ROWS, afisandu-se in DBMS OUTPUT Codul erorii si un mesaj corespunzator.
--Acum, sa presupunem ca citim de la tastatura valoarea pentru salariu 1234. In tabelul 
--employees_copy_sri nu avem niciun angajat cu acest salariu, insa in DBMS OUTPUT nu se 
--afiseaza mesajele aferente exceptiei de NO_DATA_FOUND deoarece PL/SQL a executat de fapt
--DELETE-ul, stergand liniile care respecta conditia ca salariul sa fie 1234, aceste linii
--fiind in numar de zero. Asadar, nu se intra in exceptia de NO_DATA_FOUND.In cazul in care 
--citim de la tastatura, de pilda, angajatul cu salariul 4000, acesta va fi sters din 
--tabel deoarece angajatul exista, iar salariul sau este unic. 

--CAZUL IN CARE DELETE PRESUPUNE STERGEREA MAI MULTOR LINII
DECLARE
    first_name_sri employees.first_name%TYPE;  
    last_name_sri employees.last_name%TYPE;
    email_sri employees.email%TYPE;
    salary_sri number := &p_salary_sri;
BEGIN 
    DELETE FROM employees_copy_sri
    WHERE employee_id IN (100, 105, 106)
    RETURNING first_name, last_name, email INTO first_name_sri, last_name_sri, email_sri;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE ('Aveti o eroare cu codul ' ||SQLCODE || '!');
        DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu salariul dat!');
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Aveti o eroare cu codul ' || SQLCODE || '!');
        DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati cu salariul dat!');
END;
--Sa presupunem ca vrem sa stergem angajatii cu salariul 4800, care au id-urile 100,105 
--sau 106. Observam cu select * ca atat angajatul 105, cat si angajatul 106 au salariul
--4800. De aceea, vom primi o eroare cu codul -1422, care ne spune ca exista mai multi
--angajati cu salariul dat. 


--UPDATE...RETURNING INTO 

SELECT * FROM departments_copy_sri;

DECLARE 
    dep_name_sri VARCHAR2(30 BYTE) := &p_dep_name_sri;
    loc_id_sri departments.location_id%TYPE;
    nr_department NUMBER := 20;
BEGIN
    UPDATE departments_copy_sri
    SET department_name = dep_name_sri
    WHERE department_id = nr_department
--  WHERE location_id = 1700 --va genera eroare de too many rows
    RETURNING department_name, location_id INTO dep_name_sri, loc_id_sri;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE ('Aveti o eroare cu codul ' ||SQLCODE || '!');
        DBMS_OUTPUT.PUT_LINE('Nu exista departamentul cu codul 20!');
    WHEN TOO_MANY_ROWS THEN 
        DBMS_OUTPUT.PUT_LINE('Aveti o eroare cu codul ' || SQLCODE || '!');
        DBMS_OUTPUT.PUT_LINE('Exista mai multe departamente cu codul 20!');
--      DBMS_OUTPUT.PUT_LINE('Exista mai multe locatii cu codul 1700!');
END;    

--Sa presupunem ca vrem sa actualizam numele departamentului cu id-ul 20. Acest lucru va functiona, 
--deoarece id-ul exista si este unic. In cazul in care am vrea, de pilda, sa actualizam numele
--unui departament care nu se afla in baza de date, analog situatiei de la DELETE, PL/SQL va
--executa UPDATE-ul pe o valoare ce nu exista, deci nu se va produce nicio modificare. 
--Mesajul de eroare apare in cazul in care dorim, de exemplu, sa actualizam numele departamentelor
--pentru care codul locatiei este 1700. Intrucat exista mai multe departamente cu acelasi cod, 
--se va trata exceptia de TOO_MANY_ROWS, afisandu-se mesajele corespunzatoare acesteia. 

--ex2.
--Dati 3 exemple asemanatoare cu  exemplele 3.13, 3.14, 3.15, 3.16) in care sa folositi
--CASE din SQL, respectiv din PL/SQL astfel incat sa afisati pentru un departament dat de la tastatura 
--cati angajati lucreaza in acel departament. Se vor afisa mesaje corespunzatoare folosind comanda CASE
--din PL/SQL, dar si expresia CASE din SQL. Departamentele vor fi alese astfel incat sa lucreze in ele 
--1 singur angajat, mai multi angajati sau niciun angajat.

select * from departments_copy_sri;
select * from employees_copy_sri;

--exemplul 1 -----> CASE din PL/SQL
DECLARE
    employees_nr_sri NATURAL;
    dep_id_sri NUMBER := &p_depid_sri;
BEGIN 
    SELECT COUNT(*) INTO employees_nr_sri
    FROM employees_copy_sri
    WHERE department_id = dep_id_sri;
    CASE employees_nr_sri
        WHEN 0 THEN 
            DBMS_OUTPUT.PUT_LINE ('In departamentul ' || dep_id_sri || ' nu este niciun angajat!');
        WHEN 1 THEN 
            DBMS_OUTPUT.PUT_LINE('In departamentul ' || dep_id_sri || ' este doar un angajat!');
        ELSE
            DBMS_OUTPUT.PUT_LINE('In departamentul ' || dep_id_sri || ' sunt ' || employees_nr_sri || ' angajati!');
    END CASE;
END;

--exemplul 2 ----> CASE din SQL

UNDEFINE p_depid_sri
SELECT
    CASE WHEN COUNT(*) = 0
                THEN 'In departamentul ' || ('&&p_depid_sri') || ' nu este niciun angajat! '
         WHEN COUNT(*) = 1
                THEN 'In departamentul ' || ('&&p_depid_sri') || ' exista un angajat! '
         ELSE 'In departamentul ' || ('&&p_depid_sri') || ' sunt ' || COUNT(*) || ' angajati!'
         END AS "NUMAR ANGAJATI" 
FROM employees_copy_sri
WHERE department_id = ('&p_depid_sri');

--exemplul 3 ----> CASE DIN SQL IN CADRUL UNUI BLOC DIN PL/SQL

UNDEFINE p_depid_sri
DECLARE     
    employees_nr_sri NATURAL;
    dep_id_sri NUMBER := &p_depid_sri;
    output_sri VARCHAR2(100 BYTE);
BEGIN 
    SELECT COUNT(*) INTO employees_nr_sri
    FROM employees_copy_sri
    WHERE department_id = dep_id_sri;
output_sri := CASE
    WHEN employees_nr_sri = 0 THEN 'In departamentul ' || dep_id_sri || ' nu este niciun angajat!'
    WHEN employees_nr_sri = 1 THEN 'In departamentul ' || dep_id_sri || ' este doar un angajat!'
    ELSE 'In departamentul ' || dep_id_sri || ' sunt ' || employees_nr_sri || ' angajati!'
    END;
DBMS_OUTPUT.PUT_LINE(output_sri);
END;
    














