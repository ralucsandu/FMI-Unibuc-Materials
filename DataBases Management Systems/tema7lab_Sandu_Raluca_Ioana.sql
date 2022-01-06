--Tema 7 laborator SGBD 
--Realizata de: Sandu Raluca-Ioana
--Grupa: 242

--ex1. Pentru fiecare job (titlu – care va fi afisat o singura data) obtineti lista angajatilor (nume si
--salariu) care lucreaza în prezent pe jobul respectiv. Tratati cazul în care nu exista angajati care 
--sa lucreze în prezent pe un anumit job. Rezolvati problema folosind:

--a) cursoare clasice    
DECLARE 
    job_salariu_aux jobs_rsa%ROWTYPE;
    ang_salariu_aux emp_rsa%ROWTYPE;
    nr_ang NUMBER;
    CURSOR C IS  
        SELECT *
        FROM jobs_rsa;    
    CURSOR A (parametru VARCHAR2) IS
        SELECT *
        FROM emp_rsa emp
        WHERE emp.job_id = parametru;
BEGIN
    OPEN C;
    LOOP
        FETCH C INTO job_salariu_aux;
        EXIT WHEN C%NOTFOUND;   
        DBMS_OUTPUT.PUT_LINE('Nume job: ' || job_salariu_aux.job_title);
        
        OPEN A(job_salariu_aux.job_id);
        nr_ang := 0; 
        LOOP
            FETCH A INTO ang_salariu_aux;
            EXIT WHEN A%NOTFOUND;
            nr_ang := nr_ang + 1;
            DBMS_OUTPUT.PUT_LINE('  '|| ang_salariu_aux.first_name || ' ' || ang_salariu_aux.last_name 
                                || ', salariu: ' || ang_salariu_aux.salary);
        END LOOP;
        CLOSE A;
        IF nr_ang = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  Niciun angajat cu acest job!');
        END IF;
    END LOOP;
    CLOSE C;
END;
/
--b) ciclu cursoare
DECLARE     
    job_salariu_aux jobs_rsa%ROWTYPE;
    ang_salariu_aux emp_rsa%ROWTYPE;
    nr_ang NUMBER;
    CURSOR C IS  
        SELECT *
        FROM jobs_rsa;
    CURSOR A (parametru VARCHAR2) IS
        SELECT *
        FROM emp_rsa emp
        WHERE emp.job_id = parametru;
BEGIN
    FOR job_salariu_aux IN C LOOP
        DBMS_OUTPUT.PUT_LINE('Nume job: ' || job_salariu_aux.job_title);
    nr_ang := 0;   
    FOR ang_salariu_aux IN A(job_salariu_aux.job_id) LOOP
            nr_ang := nr_ang + 1;
            DBMS_OUTPUT.PUT_LINE('  ' || ang_salariu_aux.first_name || ' ' || ang_salariu_aux.last_name 
                                || ', salariu: ' || ang_salariu_aux.salary);
        END LOOP;
        IF nr_ang = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  Niciun angajat cu acest job!');
        END IF;
    END LOOP;
END;
/
--c)ciclu cursoare cu subcereri
DECLARE
    nr_ang NUMBER;
BEGIN
    FOR job_salariu_aux IN 
            (SELECT *
             FROM jobs_rsa) LOOP
        DBMS_OUTPUT.PUT_LINE('Nume job: ' || job_salariu_aux.job_title);
        nr_ang := 0;
        FOR ang_salariu_aux IN 
            (SELECT *
             FROM emp_rsa emp
             WHERE emp.job_id = job_salariu_aux.job_id) LOOP
            nr_ang := nr_ang + 1;
            DBMS_OUTPUT.PUT_LINE('  ' || ang_salariu_aux.first_name || ' ' || ang_salariu_aux.last_name 
                                || ', salariu: ' || ang_salariu_aux.salary);
        END LOOP;
        IF nr_ang = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  Niciun angajat cu acest job!');
        END IF;
    END LOOP;
END;
/
--d)cu expresii cursor
DECLARE 
    TYPE refcursor IS REF CURSOR;
    CURSOR C IS 
            (SELECT j.job_title, CURSOR (SELECT *
                                         FROM emp_rsa emp
                                         WHERE emp.job_id = j.job_id)
             FROM jobs_rsa j);
    job_salariu_aux VARCHAR2(200);
    ang_salariu_aux emp_rsa%ROWTYPE;
    nr_ang NUMBER;
    v_cursor refcursor;
BEGIN
    OPEN C;
    LOOP
        FETCH C INTO job_salariu_aux, v_cursor;
        EXIT WHEN C%NOTFOUND;  
        DBMS_OUTPUT.PUT_LINE('Nume job: ' || job_salariu_aux);
        nr_ang := 0; 
        LOOP
            FETCH v_cursor INTO ang_salariu_aux;
            EXIT WHEN v_cursor%NOTFOUND;
     
            nr_ang := nr_ang + 1;
            DBMS_OUTPUT.PUT_LINE('  ' || ang_salariu_aux.first_name || ' ' || ang_salariu_aux.last_name 
                                || ', salariu: ' || ang_salariu_aux.salary);
        END LOOP;
        IF nr_ang = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  Niciun angajat cu acest job!');
        END IF;
    END LOOP;
    CLOSE C;
END;
/
--ex2.

--Modificati exercitiul anterior astfel încât sa obtineti si urmatoarele informatii:
-- un numar de ordine pentru fiecare angajat care va fi resetat pentru fiecare job
-- pentru fiecare job
--------- numarul de angajati 
--------- valoarea lunara a veniturilor angajatilor 
--------- valoarea medie a veniturilor angajatilor 
-- indiferent job
--------- numarul total de angajati
--------- valoarea totala lunara a veniturilor angajatilor
--------- valoarea medie a veniturilor angajatilor

DECLARE
    nr_ang_job NUMBER;
    nr_ang_total NUMBER;
    suma_salarii_job NUMBER;
    suma_salarii_total NUMBER;
    contor NUMBER;
    CURSOR C IS  
        SELECT *
        FROM jobs_rsa; 
    CURSOR A(parametru VARCHAR2) IS
        SELECT *
        FROM emp_rsa emp
        WHERE emp.job_id = parametru;     
BEGIN
    suma_salarii_total := 0;
    nr_ang_total := 0;
    FOR i IN C LOOP
        DBMS_OUTPUT.PUT_LINE('Job: ' || i.job_title );
        contor:=0;    
        nr_ang_job := 0;
        suma_salarii_job := 0;
        FOR j in A(i.job_id) LOOP
            nr_ang_job := nr_ang_job + 1;
            suma_salarii_job := suma_salarii_job + j.salary;
        END LOOP;
        
        suma_salarii_total := suma_salarii_total + suma_salarii_job;
        nr_ang_total := nr_ang_total + nr_ang_job;
        
        IF nr_ang_job = 1 THEN
            DBMS_OUTPUT.PUT_LINE('   In baza de date exista ' || nr_ang_job || ' angajat cu acest job.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('   In baza de date exista ' || nr_ang_job || ' angajati cu acest job. ');
        END IF;
        
        IF nr_ang_job > 0 THEN
            DBMS_OUTPUT.PUT_LINE('   Valoarea lunara a veniturilor angajatilor este ' || suma_salarii_job);
            DBMS_OUTPUT.PUT_LINE('   Valoarea medie a veniturilor angajatilor este ' || round(suma_salarii_job / nr_ang_job,2));
            DBMS_OUTPUT.PUT_LINE('   Angajatii cu acest job sunt: '); 
        END IF;
            
        FOR k IN A(i.job_id) LOOP
        contor:=contor+1;
            DBMS_OUTPUT.PUT_LINE('      ' ||contor|| ' '|| k.first_name || ' ' || k.last_name || ' | Salariu: ' || k.salary);
        END LOOP;
        
        IF nr_ang_job = 0 THEN
            DBMS_OUTPUT.PUT_LINE('    Niciun angajat cu acest job!');
        END IF;
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Numarul total de angajati este ' || nr_ang_total);
    DBMS_OUTPUT.PUT_LINE('Valoarea totala a veniturilor angajatilor este ' || suma_salarii_total || ' lei pe luna.');
    DBMS_OUTPUT.PUT_LINE('Valoarea medie a veniturilor angajatilor este ' || round(suma_salarii_total / nr_ang_total,2) || ' lei pe luna.');
END;
/
--ex3.
--Modificati exercitiul anterior astfel încât sa obtineti suma totala alocata lunar pentru plata 
--salariilor si a comisioanelor tuturor angajatilor, iar pentru fiecare angajat cat la suta din aceasta 
--suma castiga lunar.
DECLARE
    ang_salariu_aux emp_rsa%ROWTYPE;
    contor NUMBER;
    salariu_per_ang NUMBER;
    suma_salarii_total NUMBER;
    CURSOR A (parametru VARCHAR2) IS
        SELECT *
        FROM emp_rsa emp
        WHERE emp.job_id = parametru;    
    CURSOR C IS  
        SELECT *
        FROM jobs_rsa;    
BEGIN
    suma_salarii_total := 0;
    FOR ang_salariu_aux IN (SELECT *
                            FROM emp_rsa) LOOP
        suma_salarii_total := suma_salarii_total+ang_salariu_aux.salary;
        IF ang_salariu_aux.commission_pct IS NOT NULL THEN
            suma_salarii_total := suma_salarii_total+ang_salariu_aux.commission_pct*ang_salariu_aux.salary;
        END IF;   
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('  Suma totala alocata lunar pentru a plati TOTI angajatii: ' || suma_salarii_total);
    DBMS_OUTPUT.NEW_LINE();
    FOR i IN C LOOP
        DBMS_OUTPUT.PUT_LINE('Job: ' || i.job_title );
        contor:=0;
        FOR j IN A (i.job_id) loop
            contor:=contor+1;
        salariu_per_ang := j.salary;
        IF j.commission_pct IS NOT NULL THEN
            salariu_per_ang := salariu_per_ang + salariu_per_ang*j.commission_pct;
        END IF;
            DBMS_OUTPUT.PUT_LINE('    ' ||contor || ' '||j.first_name ||' ' || j.last_name || ' | Salariu: ' || j.salary);
        DBMS_OUTPUT.PUT_LINE(' Aceasta suma reprezinta ' || round((100*salariu_per_ang)/suma_salarii_total, 2)
                            || ' din suma totala.'); 
        END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    IF contor = 0 THEN
        DBMS_OUTPUT.PUT_LINE('  Niciun angajat cu acest job!');
    END IF;
    END LOOP;
END;
/
--ex4.
--Modificati exercitiul anterior astfel încât sa obtineti pentru fiecare job primii 5 angajati care 
--câstiga cel mai mare salariu lunar. Specificati daca pentru un job sunt mai putin de 5 angajati.

DECLARE
    CURSOR C IS
        SELECT * FROM jobs_rsa;
    CURSOR A(parametru VARCHAR2) IS
        SELECT *
        FROM emp_rsa emp
        WHERE emp.job_id = parametru
        ORDER BY SALARY desc;
    contor NUMBER;
BEGIN 
    FOR i IN C LOOP
        DBMS_OUTPUT.PUT_LINE('Job: ' || i.job_title );
        DBMS_OUTPUT.PUT_LINE('Primii 5 angajati cu cel mai mare salariu lunar: ');
        contor:=0;
        FOR j IN A (i.job_id) loop
            contor:=contor+1;
            DBMS_OUTPUT.PUT_LINE('    ' ||contor || ' '||j.first_name ||' ' || j.last_name || ' | Salariu: ' || j.salary);
            EXIT WHEN contor>=5;
        END LOOP;
        IF (contor<5) THEN
            DBMS_OUTPUT.PUT_LINE('    Mai putin de 5 angajati cu acest job!');
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/
--insert pentru verificare
INSERT INTO jobs_rsa (job_id, job_title, min_salary, max_salary)
            VALUES ('PP_MEP', 'Naval architect', 3000, 20000);

SELECT * FROM emp_rsa;
select * from jobs_rsa;

INSERT INTO emp_rsa (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, 
                      commission_pct, manager_id, department_id) 
        VALUES(207, 'Mary', 'Dima', 'DIMPLAYS', '0722891230', to_date('23-OCT-2021', 'DD-MON-YYYY'), 
              'FI_ACCOUNT', 7700, NULL, 108, 100);
--ex5.
--Modificati exercitiul anterior astfel încât sa obtineti pentru fiecare job top 5 angajati. Daca 
--exista mai multi angajati care respecta criteriul de selectie care au acelasi salariu, atunci acestia 
--vor ocupa aceeasi pozitie în top 5.
DECLARE
    CURSOR C IS
        SELECT * FROM jobs_rsa;
    CURSOR A(parametru VARCHAR2) IS
        SELECT *
        FROM emp_rsa emp
        WHERE emp.job_id = parametru
        ORDER BY SALARY desc;
    contor NUMBER;
    salariu_aux NUMBER;
BEGIN 
    FOR i IN C LOOP
        DBMS_OUTPUT.PUT_LINE('Job: ' || i.job_title );
        DBMS_OUTPUT.PUT_LINE('TOP 5 Cei mai bine platiti angajati: ');
        contor:=0;
        salariu_aux:=0;
        FOR j IN A (i.job_id) LOOP
            IF(salariu_aux<>j.salary) THEN 
                contor:=contor+1;
                salariu_aux:=j.salary;
            END IF;
        DBMS_OUTPUT.PUT_LINE('    ' ||contor || ' '|| j.last_name || ' ' || j.salary);
        EXIT WHEN contor>=5; --iesim din loop dupa ce am alcatuit topul
        END LOOP;
        IF (contor<5) THEN
            DBMS_OUTPUT.PUT_LINE('    Mai putin de 5 angajati cu acest job!');
        END IF;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END;
/
--exemplul 5: rezolvare care sa rezolve problema pentru top 3 valori (nr. subordonati)
DECLARE
  v_cod    employees.employee_id%TYPE;
  v_nume   employees.last_name%TYPE;
  v_nr     NUMBER(4);
  CURSOR c IS
    SELECT   sef.employee_id cod, MAX(sef.last_name) nume, 
             count(*) nr
    FROM     employees sef, employees ang
    WHERE    ang.manager_id = sef.employee_id
    GROUP BY sef.employee_id
    ORDER BY nr DESC;
  pozitie_top number:=0;
  v_nr_precedent number;
BEGIN
  OPEN c;
    pozitie_top:=1;
    FETCH c INTO v_cod,v_nume,v_nr;
    DBMS_OUTPUT.PUT_LINE(pozitie_top||' Managerul '|| v_cod || 
                         ' avand numele ' || v_nume || 
                         ' conduce ' || v_nr||' angajati');
    v_nr_precedent:=v_nr;
    LOOP
      FETCH c INTO v_cod,v_nume,v_nr;
      IF v_nr <> v_nr_precedent THEN
        pozitie_top:=pozitie_top+1;
      END IF;   
      v_nr_precedent:=v_nr;
      EXIT WHEN pozitie_top>3 OR c%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(pozitie_top || ' Managerul '|| v_cod || 
                           ' avand numele ' || v_nume || 
                           ' conduce ' || v_nr||' angajati');
    END LOOP;
  CLOSE c;
END;
/