--TEMA 11 LABORATOR SGBD
--Sandu Raluca-Ioana, grupa 242

--EX1.

SELECT user FROM dual; --GRUPA242   

CREATE OR REPLACE TRIGGER trig1_rsa
    BEFORE DELETE ON departments_copy_sri
BEGIN
    IF user <> 'SCOTT' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Nu te numesti SCOTT. Nu ai voie sa stergi informatii din tabel!');
    END IF;
END;
/
DELETE FROM departments_copy_sri
WHERE department_id=102;   --eroare deoarece numele meu de user nu este SCOTT, ci GRUPA242
/
DROP TRIGGER trig1_rsa;

--EX2.

CREATE OR REPLACE TRIGGER trig2_rsa
    BEFORE UPDATE OF commission_pct ON employees_copy_sri
    FOR EACH ROW
BEGIN
    IF :OLD.salary * ( 1 + NVL(:NEW.commission_pct,0)) > :OLD.salary * 0.5 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Marirea comisionului determina depasirea a 50% din valoarea salariului!');
    END IF;
END;
/

SELECT * FROM employees_copy_sri;

UPDATE employees_copy_sri
SET commission_pct = 0.8
WHERE employee_id = 100;    --primim o eroare deoarece marirea comisionului determina depasirea a 50% din salariu

--DROP TRIGGER trig2_rsa;

--EX3.
--a)
CREATE TABLE info_dept_rsa( 
    id NUMBER(4,0) PRIMARY KEY, 
    nume_dept VARCHAR2(30 BYTE), 
    plati NUMBER(10,2),
    numar NUMBER(4)
); 

INSERT INTO info_dept_rsa 
SELECT department_id, department_name, nvl(sum(salary), 0), count(*) 
FROM departments JOIN employees USING (department_id) 
GROUP BY department_id, department_name; 

CREATE TABLE info_emp_rsa (
    id number(3) primary key, 
    nume varchar2(50), 
    prenume varchar2(50), 
    salariu number(6), 
    id_dept number(3) references info_dept_rsa
    ); 
    
insert into info_emp_rsa 
select employee_id, last_name, first_name, salary, department_id 
from employees; 

--b)
CREATE OR REPLACE TRIGGER trig3_rsa
    AFTER INSERT OR UPDATE OR DELETE ON info_emp_rsa
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE info_dept_rsa
        SET numar = numar + 1
        WHERE id = :NEW.id_dept;
    
    ELSIF UPDATING THEN
        UPDATE info_dept_rsa
        SET numar = numar - 1 
        WHERE id = :OLD.id_dept;
        
        UPDATE info_dept_rsa
        SET numar = numar + 1
        WHERE id = :NEW.id_dept;
        
    ELSIF DELETING THEN
        UPDATE info_dept_rsa
        SET numar = numar - 1
        WHERE id = :OLD.id_dept;
    
    END IF;
END;
/

select * from info_dept_rsa;
select * from info_emp_rsa;

INSERT INTO info_emp_rsa VALUES(300, 'NUME', 'PRENUME', 22000, 10);

UPDATE info_emp_rsa   --functioneaza :)
SET id_dept = 20
WHERE id = 300;

DELETE info_emp_rsa --functioneaza :)
WHERE id = 300; 

--DROP TRIGGER trig3_rsa;

--EX4.
CREATE OR REPLACE TRIGGER trig41_rsa
    AFTER INSERT OR UPDATE OR DELETE ON info_emp_rsa
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE info_dept_rsa
        SET numar = numar + 1
        WHERE id = :NEW.id_dept;
    
    ELSIF UPDATING THEN
        UPDATE info_dept_rsa
        SET numar = numar - 1 
        WHERE id = :OLD.id_dept;
        
        UPDATE info_dept_rsa
        SET numar = numar + 1
        WHERE id = :NEW.id_dept;
        
    ELSIF DELETING THEN
        UPDATE info_dept_rsa
        SET numar = numar - 1
        WHERE id = :OLD.id_dept;
    
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trig42_rsa
    BEFORE INSERT OR UPDATE ON info_emp_rsa 
    FOR EACH ROW
DECLARE
    nr_angajati NUMBER;
BEGIN
    SELECT numar INTO nr_angajati 
    FROM info_dept_rsa
    WHERE id =:NEW.id_dept;
    
    IF nr_angajati = 45 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu pot lucra mai mult de 45 de angajati in departament!');
    END IF;
END;
/
INSERT INTO info_emp_rsa VALUES(300, 'NUME', 'PRENUME', 2000, 50); --eroare deoarece in departamentul
                                                                   --50 deja lucreaza 45 de angajati
                                                                   
INSERT INTO info_emp_rsa VALUES(300, 'NUME', 'PRENUME', 2000, 100); --asa imi face insertul :) 
--ROLLBACK;

--EX5

--a)
CREATE TABLE emp_test_rsa AS 
SELECT employee_id, last_name, first_name, department_id
FROM employees;

ALTER TABLE emp_test_rsa 
ADD primary key(employee_id);

CREATE TABLE dept_test_rsa AS
SELECT department_id, department_name
FROM departments;

ALTER TABLE dept_test_rsa
ADD primary key(department_id);

--b)
CREATE OR REPLACE TRIGGER trig5_rsa
    AFTER UPDATE OR DELETE ON dept_test_rsa
    FOR EACH ROW
BEGIN
    IF UPDATING THEN
        UPDATE emp_test_rsa 
        SET department_id =:NEW.department_id
        WHERE department_id =:OLD.department_id;
        
    ELSIF DELETING THEN
        DELETE FROM emp_test_rsa
        WHERE department_id =:OLD.department_id;
    END IF;
END;
/

UPDATE dept_test_rsa  --functioneaza :) 
SET department_id = 360
WHERE department_id = 60;

select * from emp_test_rsa;
select * from dept_test_rsa;
rollback;

DELETE from dept_test_rsa  --functioneaza :) 
WHERE department_id = 60;

--DROP TRIGGER trig5_rsa;

--EX6.
--a)
CREATE TABLE info_erori_rsa(
    user_id VARCHAR2(25 BYTE),
    nume_bd VARCHAR2(50 BYTE),
    erori VARCHAR2(200 BYTE),
    data DATE
    );
    
--b)
CREATE OR REPLACE TRIGGER trig6_rsa
    AFTER SERVERERROR ON schema
BEGIN
    INSERT into info_erori_rsa VALUES(SYS.LOGIN_USER, SYS.DATABASE_NAME, DBMS_UTILITY.FORMAT_ERROR_STACK, sysdate);
END;
/

--DROP trigger trig6_rsa;

UPDATE dept_dcr
SET department_id = 98
WHERE department_id = 50;

select * from dept_dcr;
INSERT INTO dept_dcr(department_id, department_name) VALUES(99, 'NUME');

--EX3.
DECLARE 
    v_cod_dep NUMBER := &v_cod;
    exceptie_dep exception;
    pragma exception_init(exceptie_dep, -02292);
    
BEGIN
    UPDATE dept_dcr
    SET department_id = 98
    WHERE department_id = v_cod_dep;
EXCEPTION
    WHEN exceptie_dep THEN
        DBMS_OUTPUT.PUT_LINE('Nu puteti modifica codul departamentului acesta, deoarece are angajati!');
END;

--EX4.
DECLARE
    v_min NUMBER := &v_min;
    v_max NUMBER := &v_max;
    v_nume dept_dcr.department_name%TYPE;
    nr_angajati NUMBER;
    exceptie_interval exception;
BEGIN
    SELECT COUNT(*) INTO nr_angajati 
    FROM emp_dcr
    WHERE department_id = 10;
    
    SELECT department_name INTO v_nume
    FROM dept_dcr
    WHERE department_id = 10;

    IF nr_angajati < v_min OR nr_angajati > v_max THEN
        RAISE exceptie_interval;
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_nume);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista departamentul cu id-ul 10!');
    WHEN exceptie_interval THEN
        DBMS_OUTPUT.PUT_LINE('Numarul de angajati nu se afla in intervalul specificat!');
END;