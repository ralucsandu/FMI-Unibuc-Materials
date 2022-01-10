--imi creez inca un tabel, pentru ca in tabelul meu(emp_rsa) am facut diferite inserturi si nu 
--mai este la fel ca tabelul original employees.

CREATE TABLE emp_rsa_copy AS SELECT * FROM employees;

CREATE OR REPLACE PACKAGE ex1_rsa AS 
            ----------DE AICI INCEPE TEMA AFERENTA LABORATORULUI 10----------
----------------------------------------------------------------------------------------------------------c
FUNCTION nr_subalterni(nume_ang emp_rsa_copy.last_name%TYPE,
                       prenume_ang emp_rsa_copy.first_name%TYPE)
    RETURN number;                    
----------------------------------------------------------------------------------------------------------d
PROCEDURE promoveaza_angajat(nume_ang emp_rsa_copy.last_name%TYPE,
                             prenume_ang emp_rsa_copy.first_name%TYPE);
----------------------------------------------------------------------------------------------------------e
PROCEDURE actualizeaza_salariu(nume_ang emp_rsa_copy.last_name%TYPE,
                               salariu_dat emp_rsa_copy.salary%TYPE);
----------------------------------------------------------------------------------------------------------f
CURSOR cursor_f(cod_job jobs_rsa.job_id%TYPE)
    RETURN emp_rsa_copy%ROWTYPE;
----------------------------------------------------------------------------------------------------------g
CURSOR cursor_g 
    RETURN jobs_rsa%ROWTYPE;
----------------------------------------------------------------------------------------------------------h
PROCEDURE lista_joburi;
-----------------------------------------------------------------------------------------------------------
END ex1_rsa;
/

CREATE OR REPLACE PACKAGE BODY ex1_rsa AS 
------------------DE AICI INCEPE TEMA AFERENTA LABORATORULUI 10-------------------
--f)
CURSOR cursor_f(cod_job jobs_rsa.job_id%TYPE) 
    RETURN emp_rsa_copy%ROWTYPE
    IS
        SELECT * FROM emp_rsa_copy
        WHERE job_id = cod_job;

--g)
CURSOR cursor_g 
    RETURN jobs_rsa%ROWTYPE
    IS 
        SELECT * 
        FROM jobs_rsa;
        
--c)
FUNCTION nr_subalterni(nume_ang emp_rsa_copy.last_name%TYPE,
                       prenume_ang emp_rsa_copy.first_name%TYPE)
    RETURN number IS
    nr_ang number;
BEGIN
    SELECT count(employee_id)-1 INTO nr_ang
    FROM emp_rsa_copy
    START WITH last_name = nume_ang AND first_name = prenume_ang
    CONNECT BY manager_id = PRIOR employee_id;

    IF nr_ang=0 THEN 
        RAISE NO_DATA_FOUND;
        RETURN -1;
    END IF;
    
    RETURN nr_ang;
    
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Niciun manager cu acest nume!');
 
    WHEN TOO_MANY_ROWS THEN  
        DBMS_OUTPUT.PUT_LINE('Mai multi manageri cu acest nume');
END nr_subalterni;

--d) incercare
PROCEDURE promoveaza_angajat(nume_ang emp_rsa_copy.last_name%TYPE,
                             prenume_ang emp_rsa_copy.first_name%TYPE) IS
    cod_manager emp_rsa_copy.employee_id%TYPE;
    cod_angajat emp_rsa_copy.employee_id%TYPE;
    TYPE coduri IS TABLE OF emp_rsa_copy.employee_id%TYPE;
    tabel_coduri coduri := coduri();
BEGIN
    SELECT employee_id INTO cod_angajat
    FROM emp_rsa_copy 
    WHERE last_name = nume_ang AND first_name = prenume_ang;
    
    SELECT manager_id INTO cod_manager
    FROM emp_rsa_copy
    WHERE employee_id = cod_angajat;
    
    SELECT employee_id BULK COLLECT INTO tabel_coduri 
    FROM emp_rsa_copy
    WHERE manager_id = cod_manager;
    
    FOR cod in tabel_coduri.first..tabel_coduri.last LOOP
        UPDATE emp_rsa_copy
        SET manager_id = cod_angajat
        WHERE employee_id = tabel_coduri(cod) AND employee_id <> cod_angajat;
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN 
        RAISE_APPLICATION_ERROR(-20000, 'Niciun angajat cu numele dat!');
    WHEN TOO_MANY_ROWS THEN 
        RAISE_APPLICATION_ERROR(-20001, 'Prea multi angajati cu numele dat!');
END promoveaza_angajat;
    
--e)
PROCEDURE actualizeaza_salariu(nume_ang emp_rsa_copy.last_name%TYPE,
                               salariu_dat emp_rsa_copy.salary%TYPE) IS                        
    sal_max number;
    sal_min number;
    nr_ang number;
    TYPE ang_cu_acelasi_nume IS TABLE OF emp_rsa_copy%ROWTYPE INDEX BY BINARY_INTEGER;
    t ang_cu_acelasi_nume;
BEGIN
    
    SELECT *
    BULK COLLECT INTO t
    FROM emp_rsa_copy 
    WHERE last_name = nume_ang;
    
    SELECT count(*) INTO nr_ang
    FROM emp_rsa_copy
    WHERE last_name = nume_ang;
    
    IF nr_ang > 1 THEN
        RAISE TOO_MANY_ROWS;
        
    ELSIF nr_ang > 0 THEN

         SELECT min_salary INTO sal_min 
         FROM jobs_rsa
         WHERE job_id = (SELECT job_id
                         FROM emp_rsa_copy
                         WHERE last_name = nume_ang);
        
        SELECT max_salary INTO sal_max
        FROM jobs_rsa
        WHERE job_id = (SELECT job_id
                        FROM emp_rsa_copy
                        WHERE last_name = nume_ang);
                        
         IF salariu_dat >= sal_min AND salariu_dat<=sal_max THEN
            UPDATE emp_rsa_copy
            SET salary = salariu_dat
            WHERE last_name = nume_ang;
            DBMS_OUTPUT.PUT_LINE('Noul salariu al angajatului cu numele de familie ' || nume_ang || ' : ' || salariu_dat);
         
         ELSE 
            DBMS_OUTPUT.PUT_LINE('Noul salariu nu respecta limitele impuse pentru acest job!');
         END IF;
         
    ELSE
        RAISE NO_DATA_FOUND;
    END IF;
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Niciun angajat cu acest nume!');

    WHEN TOO_MANY_ROWS THEN  
        DBMS_OUTPUT.PUT_LINE('Mai multi angajati cu acest nume! Acestia sunt urmatorii: ');
        FOR i IN 1..t.COUNT LOOP
            IF t.EXISTS(i) THEN
            DBMS_OUTPUT.PUT('   ' || t(i).last_name 
                            || ' ' || t(i).first_name);
            DBMS_OUTPUT.NEW_LINE;
            END IF;
        END LOOP;
        
END actualizeaza_salariu;

--h)
PROCEDURE lista_joburi IS
    nr_ang NUMBER:=0;
    lista emp_rsa_copy%ROWTYPE;
    de_cate_ori_a_mai_avut_jobul NUMBER :=0;
BEGIN

    FOR i IN cursor_g LOOP
        DBMS_OUTPUT.PUT_LINE('  Nume job: ' || i.job_title);
        DBMS_OUTPUT.PUT_LINE('  Lista angajati:');
        
        SELECT COUNT(employee_id) INTO nr_ang
        FROM emp_rsa_copy
        WHERE job_id = i.job_id;
        
        IF nr_ang > 0 THEN
            FOR j IN cursor_f(i.job_id) LOOP
            
                SELECT count(employee_id) INTO de_cate_ori_a_mai_avut_jobul
                FROM emp_rsa_copy JOIN job_history_rsa USING (employee_id)
                WHERE employee_id = j.employee_id;
                
                IF de_cate_ori_a_mai_avut_jobul > 0 THEN
                    DBMS_OUTPUT.PUT_LINE('    '|| j.last_name || ' ' || j.first_name || ' a mai avut jobul in trecut!');
                ELSE 
                    DBMS_OUTPUT.PUT_LINE('    '|| j.last_name || ' ' || j.first_name || ' nu a mai avut jobul in trecut!');
                END IF;
            de_cate_ori_a_mai_avut_jobul:=0;
            END LOOP;
        ELSE 
            DBMS_OUTPUT.PUT_LINE('  Niciun angajat cu acest job!');
        END IF;
            DBMS_OUTPUT.NEW_LINE();
    END LOOP;
        
END lista_joburi;

END ex1_rsa;
/

--verificare punctul c
BEGIN
    DBMS_OUTPUT.PUT_LINE('King Steven are ' || ex1_rsa.nr_subalterni('King', 'Steven') || ' subalterni');
EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE ('S-a produs o eroare ' || sqlcode || ' cu mesajul : ' || sqlerrm);
END;
/

select * from emp_rsa_copy join jobs_rsa using (job_id);

--verificare punctul d
BEGIN
    ex1_rsa.promoveaza_angajat('Raluca', 'Ste');
EXCEPTION
    WHEN OTHERS THEN    
        DBMS_OUTPUT.PUT_LINE ('S-a produs o eroare ' || sqlcode || ' cu mesajul : ' || sqlerrm);
END;
/

--verificare punctul e
BEGIN
    ex1_rsa.actualizeaza_salariu('Tobias', 35000);
END;
/
BEGIN
    ex1_rsa.actualizeaza_salariu('King', 35000);
END;
/
BEGIN
    ex1_rsa.actualizeaza_salariu('Austin', 4900);
END;
/
ROLLBACK;
/

--verificare punctul h)
BEGIN
    ex1_rsa.lista_joburi; --afiseaza bine :) 
END;
/

select employee_id
from job_history join employees using (employee_id);

select employee_id, last_name, first_name, job_title
from emp_rsa_copy join jobs_rsa using (job_id)
where employee_id in (101, 102, 114, 122, 176, 200, 201);
