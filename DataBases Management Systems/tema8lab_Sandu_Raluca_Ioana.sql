--Tema laborator 8 SGBD
--Realizata de : Sandu Raluca-Ioana
--Grupa 242

--ex1. Creati tabelul info_*** cu urmatoarele coloane:
--- utilizator (numele utilizatorului care a initiat o comanda) 
--- data (data si timpul la care utilizatorul a initiat comanda)
--- comanda (comanda care a fost initiata de utilizatorul respectiv)
--- nr_linii (numarul de linii SELECTate/modificate de comanda)
--- eroare (un mesaj pentru exceptii)

CREATE TABLE info_rsa
    (utilizator VARCHAR2(50),
     data DATE,
     comanda VARCHAR2(50),
     nr_linii NUMBER,
     eroare VARCHAR2(200));

--ex2. Modificati functia definita la exercitiul 2, respectiv procedura definita 
--la exercitiul 4 astfel incat sa determine inserarea în tabelul info_*** a informatiilor
--corespunzatoare fiecarui caz determinat de valoarea data pentru parametru:
--- exista un singur angajat cu numele specificat;
--- exista mai multi angajati cu numele specificat;
--- nu exista angajati cu numele specificat.  

--functia de la ex2
CREATE OR REPLACE FUNCTION f2_rsa
    (v_nume emp_rsa.last_name%TYPE DEFAULT 'Bell')
RETURN NUMBER IS
    v_utilizator info_rsa.utilizator%TYPE;
    v_salariu emp_rsa.salary%TYPE;
    v_nr_linii info_rsa.nr_linii%TYPE;
BEGIN
    SELECT user INTO v_utilizator from dual;
    SELECT salary INTO v_salariu
    FROM emp_rsa
    WHERE last_name = v_nume;      
    v_nr_linii:= SQL%ROWCOUNT;
    INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f2_rsa', v_nr_linii, 'NICIO EROARE');
    RETURN v_salariu;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_nr_linii:= SQL%ROWCOUNT;
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f2_rsa', v_nr_linii,'NICIUN ANGAJAT');
        RAISE_APPLICATION_ERROR(-20000,'Nu exista angajati cu numele specificat!');

    WHEN TOO_MANY_ROWS THEN
        v_nr_linii:= SQL%ROWCOUNT;
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f2_rsa', v_nr_linii,'MAI MULTI ANGAJATI');
        RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu numele specificat!');
    WHEN OTHERS THEN
        v_nr_linii:= SQL%ROWCOUNT;
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f2_rsa',v_nr_linii,'ALTA EROARE!');
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f2_rsa;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('Salariu: ' || f2_rsa('Ernst'));
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul ' || SQLCODE || ' si mesajul ' || SQLERRM);
END;
/

SELECT * FROM info_rsa;

--procedura de la ex4
CREATE OR REPLACE PROCEDURE p4_rsa(v_nume emp_rsa.last_name%TYPE) IS 
    v_utilizator info_rsa.utilizator%TYPE;
    v_salariu emp_rsa.salary%TYPE;
    v_nr_linii info_rsa.nr_linii%TYPE;
BEGIN
    SELECT user INTO v_utilizator from dual;
    SELECT salary INTO v_salariu
    FROM emp_rsa
    WHERE last_name = v_nume;      
    v_nr_linii:= SQL%ROWCOUNT;
    INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f2_rsa', v_nr_linii, 'NICIO EROARE');
    DBMS_OUTPUT.PUT_LINE('Salariu: ' || v_salariu);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        v_nr_linii:= SQL%ROWCOUNT;
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f2_rsa', v_nr_linii,'NICIUN ANGAJAT');
        RAISE_APPLICATION_ERROR(-20000,'Nu exista angajati cu numele specificat!');

    WHEN TOO_MANY_ROWS THEN
        v_nr_linii:= SQL%ROWCOUNT;
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f2_rsa', v_nr_linii,'MAI MULTI ANGAJATI');
        RAISE_APPLICATION_ERROR(-20001,'Exista mai multi angajati cu numele specificat!');
    WHEN OTHERS THEN
        v_nr_linii:= SQL%ROWCOUNT;
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f2_rsa',v_nr_linii,'ALTA EXCEPTIE!');
        RAISE_APPLICATION_ERROR(-20002,'Alta exceptie!');
END p4_rsa;
/
BEGIN
    p4_rsa('King');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/
--ex3
--Definiti o functie stocata care determina numarul de angajati care au avut cel putin 2 joburi 
--diferite si care in prezent lucreaza intr-un v_oras dat ca parametru. Tratati cazul in care v_orasul dat 
--ca parametru nu exista, respectiv cazul in care in v_orasul dat nu lucreaza niciun angajat. Inserati 
--in tabelul info_*** informatiile corespunzatoare fiecarui caz determinat de valoarea data pentru 
--parametru. 

CREATE OR REPLACE FUNCTION f3_rsa(v_oras locations_rsa.city%TYPE) 
RETURN NUMBER IS
    v_utilizator info_rsa.utilizator%TYPE;
    oras_aux locations_rsa.city%TYPE;
    nr_ang NUMBER;
BEGIN
    SELECT user INTO v_utilizator from dual;
    SELECT city into oras_aux
    FROM locations_rsa
    WHERE city=v_oras;
    
    SELECT COUNT(*) INTO nr_ang FROM 
        (SELECT emp.employee_id, COUNT(jh.job_id)
         FROM emp_rsa emp JOIN departments_copy_sri dep ON(emp.department_id=dep.department_id)
                          JOIN locations_rsa loc ON(dep.location_id=loc.location_id)
                          JOIN job_history jh ON(emp.employee_id = jh.employee_id)
         WHERE UPPER(city)=UPPER(v_oras)
         GROUP BY emp.employee_id
         HAVING COUNT(DISTINCT jh.job_id)>=1);
    IF nr_ang = 0 THEN
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f3_rsa',0,'NU EXISTA ANGAJATI IN ORASUL DAT CA PARAMETRU');
    ELSE
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f3_rsa',1,'NICIO EROARE');  
    END IF;
    RETURN nr_ang; 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f3_rsa',-1,'NU EXISTA UN ORAS CU NUMELE DAT');
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista oras cu numele dat');
        --RETURN -1;
    WHEN TOO_MANY_ROWS THEN
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f3_rsa',-2,'EXISTA MAI MULTE ORASE CU NUMELE DAT');
        RAISE_APPLICATION_ERROR(-20001, 'Exista mai multe orase cu numele dat');
        --RETURN -2;
    WHEN OTHERS THEN
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f3_rsa',-3,'ALTA EROARE');
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
        --RETURN -3;
END f3_rsa;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('Nr angajati: ' || f3_rsa('Galati'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/
SELECT * FROM info_rsa;

--insert pentru verificare
INSERT INTO locations_rsa VALUES(3300, null, null, 'Roma', null, 'IT');
INSERT INTO locations_rsa VALUES(3400, null, null, 'Iasi', null, 'IT');

--ex4.Definiti o procedura stocata care mareste cu 10% salariile tuturor angajatilor condusi direct sau 
--indirect de catre un manager al carui cod este dat ca parametru. Tratati cazul in care nu exista
--niciun manager cu codul dat. Inserati in tabelul info_*** informatiile corespunzatoare fiecarui 
--caz determinat de valoarea data pentru parametru.

CREATE OR REPLACE PROCEDURE f4_rsa (v_manager_id emp_rsa.manager_id%TYPE )
IS
    TYPE v_ang IS TABLE OF emp_rsa.employee_id%TYPE;
    t v_ang;
    v_utilizator info_rsa.utilizator%TYPE;
    v_nr_aux NUMBER :=0;
BEGIN  
    SELECT user INTO v_utilizator from dual;
    
    SELECT COUNT(employee_id) INTO  v_nr_aux
    FROM emp_rsa
    WHERE employee_id = v_manager_id;
    
    IF v_nr_aux >0 THEN
        DBMS_OUTPUT.PUT_LINE('Exista managerul in baza de date!');
        
        SELECT employee_id
        BULK COLLECT INTO t
        FROM emp_rsa
        START WITH employee_id = v_manager_id
        CONNECT BY manager_id = PRIOR employee_id;

        IF t.count=0 THEN
            DBMS_OUTPUT.PUT_LINE('Managerul nu are subordonati!');
            INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f4_rsa',0,'Nu exista subordonati!');
            RETURN;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Modific salariul pentru angajatii cu codurile: ');
        
        FORALL i IN t.FIRST..t.LAST
            UPDATE emp_rsa
            SET salary = salary*1.10
            WHERE employee_id=t(i);
        
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f4_rsa',1,'Salariu majorat cu 10%');
        
        ELSE
            INSERT INTO info_rsa VALUES(v_utilizator, sysdate, 'f4_rsa', 0, 'Nu exista managerul in baza de date!');
        END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        INSERT INTO info_rsa VALUES(v_utilizator,sysdate,'f4_rsa',-3,'Alta eroare!');
        RAISE_APPLICATION_ERROR(-40002,'Alta eroare!');
END f4_rsa;
/

DECLARE
BEGIN
    f4_rsa('999');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/
SELECT * FROM EMP_RSA;
--ROLLBACK;
SELECT * FROM info_rsa;

