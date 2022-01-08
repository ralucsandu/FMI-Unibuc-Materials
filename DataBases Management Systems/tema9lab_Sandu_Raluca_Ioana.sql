--Tema laborator 8 SGBD
--Realizata de : Sandu Raluca-Ioana
--Grupa 242

--ex5.
--varianta 1 (cea initiala, facuta in timpul laboratorului individual) :
CREATE OR REPLACE PROCEDURE f51_rsa 
IS
    TYPE v_dep IS TABLE OF departments.department_name%TYPE;
    TYPE informatii IS RECORD 
        (v_nume employees.last_name%TYPE,
         v_prenume employees.first_name%TYPE,
         v_zi varchar2(20),
         v_vechime number(4),
         v_salariu number);
    TYPE lista IS TABLE OF informatii;
    l lista;
    t v_dep;
BEGIN
    SELECT department_name BULK COLLECT INTO t FROM departments;
    
    FOR i IN 1..t.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Departamentul ' || t(i));
        
        SELECT  last_name,
                first_name,
                to_char(hire_date,'day'),
                to_number(to_char(sysdate,'yyyy'))-to_number(to_char(hire_date,'yyyy')) vechime,
                salary 
        BULK COLLECT INTO l
        FROM employees e, departments d
        WHERE e.department_id = d.department_id and d.department_name=t(i)
            AND to_char(hire_date,'day') IN (SELECT to_char(hire_date,'day') FROM employees e, departments d
                                             WHERE e.department_id = d.department_id and d.department_name=t(i)
                                             GROUP BY to_char(hire_date,'day')
                                             HAVING COUNT(to_char(hire_date,'day')) =(SELECT max(count(to_char(hire_date,'day'))) 
                                                                                      FROM employees e, departments d
                                                                                      WHERE e.department_id = d.department_id and d.department_name=t(i)
                                                                                      GROUP BY to_char(hire_date,'day')));

        IF l.count=0 THEN 
            DBMS_OUTPUT.PUT_LINE('Acest departament nu are angajati');
        ELSE
         FOR j in 1..l.count LOOP
            DBMS_OUTPUT.PUT_LINE('  Nume angajat: ' || l(j).v_nume ||' ' || l(j).v_prenume ||' | Ziua din saptamana: '||l(j).v_zi ||' | Vechime(ani): ' || l(j).v_vechime || ' | Salariu: ' || l(j).v_salariu);
         END LOOP;
        END IF;  
        DBMS_OUTPUT.NEW_LINE();
    END LOOP; 

END f51_rsa;
/
EXECUTE f51_rsa;
/

--varianta 2: verificam si daca in fiecare zi a saptamanii s-au facut angajari + 
--consideram ca la venit se adauga si comisionul
CREATE OR REPLACE PROCEDURE f52_rsa 
IS    
    TYPE zi_angajari IS RECORD
        (v_zi_fara_ang VARCHAR2(20),
         v_nr_angajari NUMBER);
    TYPE lista1 IS TABLE OF zi_angajari;
    z lista1;
    TYPE v_dep IS TABLE OF departments.department_name%TYPE;
    TYPE informatii IS RECORD 
        (v_nume employees.last_name%TYPE,
         v_prenume employees.first_name%TYPE,
         v_zi varchar2(20),
         v_vechime number(4),
         v_salariu number);
    TYPE lista IS TABLE OF informatii;
    l lista;
    t v_dep;

BEGIN
    SELECT department_name BULK COLLECT INTO t FROM departments;
    
    DBMS_OUTPUT.PUT_LINE('Verificam intai daca au fost facute angajari in fiecare zi a saptamanii!');
    DBMS_OUTPUT.NEW_LINE();
    
    SELECT to_char(hire_date,'Day'),
           COUNT(to_char(hire_date,'Day'))
    BULK COLLECT INTO z
    FROM EMPLOYEES 
    GROUP BY to_char(hire_date,'Day');
    
    FOR c in 1..z.COUNT LOOP
        IF z(c).v_nr_angajari = 0 THEN
            DBMS_OUTPUT.PUT_LINE(z(c).v_zi_fara_ang || ': Nicio angajare in aceasta zi!');
        ELSE 
            DBMS_OUTPUT.PUT_LINE(z(c).v_zi_fara_ang || ' : Au fost facute ' || z(c).v_nr_angajari || ' angajari in aceasta zi!');
        END IF;
    END LOOP;
    DBMS_OUTPUT.NEW_LINE();
    FOR i IN 1..t.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Departamentul ' || t(i));
        SELECT  last_name,
                first_name,
                to_char(hire_date,'Day'),
                to_number(to_char(sysdate,'yyyy'))-to_number(to_char(hire_date,'yyyy')) vechime,
                salary*(1 + NVL(commission_pct, 0))
        BULK COLLECT INTO l
        FROM employees e, departments d
        WHERE e.department_id = d.department_id and d.department_name=t(i)
            AND to_char(hire_date,'Day') IN (SELECT to_char(hire_date,'Day') FROM employees e, departments d
                                             WHERE e.department_id = d.department_id and d.department_name=t(i)
                                             GROUP BY to_char(hire_date,'Day')
                                             HAVING COUNT(to_char(hire_date,'Day')) =(SELECT max(count(to_char(hire_date,'Day'))) 
                                                                                      FROM employees e, departments d
                                                                                      WHERE e.department_id = d.department_id and d.department_name=t(i)
                                                                                      GROUP BY to_char(hire_date,'Day')));
        
        IF l.count=0 THEN 
            DBMS_OUTPUT.PUT_LINE('Acest departament nu are angajati');
        ELSE
        FOR j in 1..l.count LOOP
            DBMS_OUTPUT.PUT_LINE('  Nume angajat: ' || l(j).v_nume ||' ' || l(j).v_prenume ||' | Ziua din saptamana in care a fost angajat: '||l(j).v_zi ||' | Vechime(ani): ' || l(j).v_vechime || ' | Salariu: ' || l(j).v_salariu);
         END LOOP;
        END IF;  
        DBMS_OUTPUT.NEW_LINE();
    END LOOP; 

END f52_rsa;
/
EXECUTE f52_rsa;
/

--ex6
--Modificati exercitiul anterior astfel incat lista cu numele angajatilor sa apara intr-un clasament 
--creat in functie de vechimea acestora in departament. Specificati numarul pozitiei din 
--clasament si apoi lista angajatilor care ocupa acel loc. Daca doi angajati au aceeasi vechime, 
--atunci acestia ocupa aceeasi pozitie in clasament.

--ex6
CREATE OR REPLACE PROCEDURE f6_rsa 
IS
    TYPE zi_angajari IS RECORD
        (v_zi_fara_ang VARCHAR2(20),
         v_nr_angajari NUMBER);
    TYPE lista1 is TABLE OF zi_angajari;
    z lista1;
    TYPE v_dep IS TABLE OF departments.department_name%TYPE;
    TYPE informatii IS RECORD 
        (v_nume employees.last_name%TYPE,
         v_prenume employees.first_name%TYPE,
         v_zi varchar2(20),
         v_vechime number(2),
         v_salariu number);
    TYPE lista IS TABLE OF informatii;
    l lista;
    t v_dep;
    nr number; --pentru clasament
    aux number;
BEGIN
    SELECT department_name BULK COLLECT INTO t FROM departments;
    
        
    DBMS_OUTPUT.PUT_LINE('Verificam intai daca au fost facute angajari in fiecare zi a saptamanii!');
    DBMS_OUTPUT.NEW_LINE();
    
    SELECT to_char(hire_date,'Day'),
           COUNT(to_char(hire_date,'Day'))
    BULK COLLECT INTO z
    FROM EMPLOYEES 
    GROUP BY to_char(hire_date,'Day');
    
    FOR c in 1..z.COUNT LOOP
        IF z(c).v_nr_angajari = 0 THEN
            DBMS_OUTPUT.PUT_LINE(z(c).v_zi_fara_ang || ': Nicio angajare in aceasta zi!');
        ELSE 
            DBMS_OUTPUT.PUT_LINE(z(c).v_zi_fara_ang || ' : Au fost facute ' || z(c).v_nr_angajari || ' angajari in aceasta zi!');
        END IF;
    END LOOP;
    DBMS_OUTPUT.NEW_LINE();
    
    FOR i in 1..t.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Departamentul ' || t(i));
        
        SELECT  last_name,
                first_name,
                to_char(hire_date,'Day'),
                to_number(to_char(sysdate,'yyyy'))-to_number(to_char(hire_date,'yyyy')) vechime,
                salary 
        BULK COLLECT INTO l
        FROM employees e, departments d
        WHERE e.department_id = d.department_id and d.department_name=t(i)
            AND to_char(hire_date,'Day') IN (SELECT to_char(hire_date,'Day') FROM employees e, departments d
                                             WHERE e.department_id = d.department_id and d.department_name=t(i)
                                             GROUP BY to_char(hire_date,'Day')
                                             HAVING COUNT(to_char(hire_date,'Day')) = (SELECT max(count(to_char(hire_date,'Day'))) 
                                                                                       FROM employees e, departments d
                                                                                       WHERE e.department_id = d.department_id and d.department_name=t(i)
                                                                                       GROUP BY to_char(hire_date,'Day')))
        ORDER BY 4 DESC; -- ordonam datele dupa vechime pentru a crea apoi clasamentul
       
        IF l.count=0 THEN 
            DBMS_OUTPUT.PUT_LINE('Acest departament nu are angajati!');
        ELSE
        nr:=0;
        aux:=0;
        FOR j IN 1..l.COUNT LOOP
            IF aux<>l(j).v_vechime THEN --cu ajutorul lui nr si aux facem clasamentul 
                nr:=nr+1; --locul in clasament se incrementeaza doar daca vechimea s-a modificat
                aux:=l(j).v_vechime;
            END IF;
            DBMS_OUTPUT.PUT_LINE(nr||'.  Nume angajat: ' || l(j).v_nume ||' ' || l(j).v_prenume ||' | Ziua din saptamana in care a fost angajat: '||l(j).v_zi ||' | Vechime(ani): ' || l(j).v_vechime || ' | Salariu: ' || l(j).v_salariu);
            
        END LOOP;
        END IF;
        DBMS_OUTPUT.NEW_LINE();
        
    END LOOP;       
END f6_rsa;
/
EXECUTE f6_rsa;
/

--varianta 3, ex 5: continui rezolvarea facuta impreuna la laborator + punctul b (tin cont si de istoric, adica consider la 
                                                                                  --vechime doar ultima promovare in pozitie)

CREATE OR REPLACE PROCEDURE f53_rsa IS 
CURSOR C IS (
            SELECT department_name, department_id 
            FROM departments
            ); 
            
TYPE nr_zile IS TABLE OF NUMBER; 
zi_sapt nr_zile; 
v_ultima_angajare DATE;

TYPE zi_angajari IS RECORD(
                          v_zi_fara_ang VARCHAR2(20),
                          v_nr_angajari NUMBER
                          );
TYPE lista1 IS TABLE OF zi_angajari;
z lista1;

BEGIN 
    DBMS_OUTPUT.PUT_LINE('Verificam intai daca au fost facute angajari in fiecare zi a saptamanii!');
    DBMS_OUTPUT.NEW_LINE();
    
    SELECT to_char(hire_date,'D'), COUNT(to_char(hire_date,'D'))
    BULK COLLECT INTO z
    FROM EMPLOYEES 
    GROUP BY to_char(hire_date,'D');
    
    FOR a in 1..z.COUNT LOOP
        IF z(a).v_nr_angajari = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Ziua ' || z(a).v_zi_fara_ang || ': Nicio angajare in aceasta zi!');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Ziua ' || z(a).v_zi_fara_ang || ' : Au fost facute ' || z(a).v_nr_angajari || ' angajari in aceasta zi!');
        END IF;
    END LOOP;
    DBMS_OUTPUT.NEW_LINE();
    FOR dep IN C LOOP 
       DBMS_OUTPUT.PUT_LINE('Departamentul ' || dep.department_name); 
       
        SELECT TO_CHAR(hire_date, 'D') BULK COLLECT INTO zi_sapt 
        FROM employees  
        WHERE department_id = dep.department_id 
        GROUP BY to_char(hire_date, 'D') 
        HAVING COUNT(*) = ( 
                SELECT MAX(COUNT(*)) 
                FROM employees 
                WHERE department_id = dep.department_id 
                GROUP BY to_char(hire_date, 'D') 
            );  
    
        IF zi_sapt.COUNT != 0 THEN 
           FOR j in zi_sapt.FIRSt .. zi_sapt.LAST LOOP 
                DBMS_OUTPUT.PUT_LINE('  Ziua din saptamana in care au fost facute cele mai multe angajari: ' || zi_sapt(j)); 
                FOR emp in (SELECT employee_id, last_name || ' ' || first_name v_nume_angajat, salary, commission_pct, hire_date
                            FROM employees 
                            WHERE department_id = dep.department_id AND to_char(hire_date, 'D') = zi_sapt(j)) LOOP 

                      SELECT NVL(max(end_date), emp.hire_date) 
                      INTO v_ultima_angajare
                      FROM employees JOIN job_history USING (employee_id)
                      WHERE employee_id = emp.employee_id;
                
                DBMS_OUTPUT.PUT_LINE('  Nume angajat: ' || emp.v_nume_angajat 
                                    || ' | Vechimea(in ani): ' || trunc((sysdate-v_ultima_angajare)/365)
                                    || ' | Salariu: ' || emp.salary*(1 + NVL(emp.commission_pct, 0))); 
                END LOOP;
                DBMS_OUTPUT.NEW_LINE();
           END LOOP; 
        ELSE  
            DBMS_OUTPUT.PUT_LINE('  Acest departament nu are angajati! '); 
            DBMS_OUTPUT.NEW_LINE();
        END IF; 
    END LOOP; 
END; 
/ 
EXECUTE f53_rsa; 
/                    

