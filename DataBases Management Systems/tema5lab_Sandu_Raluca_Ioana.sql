--Tema 5 laborator SGBD
--Realizata de: Sandu Raluca-Ioana
--Grupa: 242

--ex9 de modificat astfel incat codul sa poata fi rulat de mai multe ori
--varianta de la laborator permite rularea codului si implicit introducerea
--datelor in tabel o singura data. Pentru a reusi rularea codului de mai multe ori,
--folosim un cursor. 

CREATE OR REPLACE TYPE subordonati_rsa AS VARRAY(10) OF NUMBER(4);
/
CREATE TABLE manageri_rsa (cod_mgr NUMBER(10),
                           nume VARCHAR2(20),
                           lista subordonati_rsa); 
DECLARE 
    v_sub   subordonati_rsa:= subordonati_rsa(100,200,300);
    v_lista manageri_rsa.lista%TYPE;
BEGIN
    INSERT INTO manageri_rsa VALUES (1, 'Mgr 1', v_sub);
    INSERT INTO manageri_rsa VALUES (2, 'Mgr 2', null);
    INSERT INTO manageri_rsa VALUES (3, 'Mgr 3', subordonati_rsa(400,500));
  
    FOR r IN (SELECT lista
              INTO v_lista
              FROM manageri_rsa
              WHERE  cod_mgr=1) 
    LOOP
        v_lista := r.lista;
    END LOOP;
              
    FOR j IN v_lista.FIRST..v_lista.LAST LOOP
        DBMS_OUTPUT.PUT_LINE (v_lista(j));
    END LOOP;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Prea multe valori returnate!');
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nicio valoare gasita!');
END;

SELECT * FROM manageri_rsa;
DROP TABLE manageri_rsa;
DROP TYPE subordonati_rsa;

--Dezavantajul este ca folosind cursor, se vor insera in tabelul manageri_rsaa aceleasi
--valori de fiecare data cand rulam codul. De aceea, varianta optima este cea de mai jos,
--care permite modificarea tabelului o singura data. Daca se va rula codul a doua oara,
--se va intra pe cazul exceptiei de TOO_MANY_ROWS si se va afisa un mesaj corespunzator

CREATE OR REPLACE TYPE subordonati_rsaa AS VARRAY(10) OF NUMBER(4);
/
CREATE TABLE manageri_rsaa (cod_mgr NUMBER(10),
    nume VARCHAR2(20),
    lista subordonati_rsaa);
DECLARE 
    v_sub subordonati_rsaa:= subordonati_rsaa(100,200,300);
    v_lista manageri_rsaa.lista%TYPE;
BEGIN
    INSERT INTO manageri_rsaa
    VALUES (1, 'Mgr 1', v_sub);
    INSERT INTO manageri_rsaa
    VALUES (2, 'Mgr 2', null);
 
    INSERT INTO manageri_rsaa
    VALUES (3, 'Mgr 3', subordonati_rsaa(400,500));
 
    SELECT lista
    INTO v_lista
    FROM manageri_rsaa
    WHERE cod_mgr=1;
 
    FOR j IN v_lista.FIRST..v_lista.LAST loop
    DBMS_OUTPUT.PUT_LINE (v_lista(j));
    END LOOP;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Prea multe valori returnate!');
END;
/
SELECT * FROM manageri_rsaa;
DROP TABLE manageri_rsaa;
DROP TYPE subordonati_rsaa;
--ex1.
--Mentineti într-o colectie codurile celor mai prost platiti 5 angajati care nu câstiga comision. 
--Folosind aceasta colectie mariti cu 5% salariul acestor angajati. Afisati valoarea veche a salariului, 
--respectiv valoarea noua a salariului. 

--cei mai prost platiti 5 angajati care nu castiga comision(id + salariu)
SELECT employee_id, salary
FROM (SELECT employee_id, salary
      FROM emp_rsa
      WHERE commission_pct IS NULL 
      ORDER BY salary)
WHERE ROWNUM <=5;

--rezolvarea propriu zisa a exercitiului 
DECLARE 
    TYPE tab_indexat IS TABLE OF emp_rsa%ROWTYPE INDEX BY BINARY_INTEGER;
    t tab_indexat;
BEGIN
--introduc in colectie angajatii inainte de a le mari salariul 
    SELECT *
    BULK COLLECT INTO t
    FROM (SELECT *
          FROM emp_rsa 
          WHERE commission_pct IS NULL 
          ORDER BY salary)
    WHERE ROWNUM <=5;
    
    FOR i IN 1..5 LOOP
        IF t.EXISTS(i) THEN
            DBMS_OUTPUT.PUT('Cod angajat: ' || t(i).employee_id 
                            || ', Salariu vechi: ' || t(i).salary);
            DBMS_OUTPUT.NEW_LINE;
        END IF;
    END LOOP;
    
DBMS_OUTPUT.NEW_LINE;

--crestem salariile angajatilor cu 5%
    UPDATE emp_rsa
    SET salary = salary * 1.05
    WHERE (employee_id,salary) IN (SELECT employee_id, salary
                                   FROM (SELECT * FROM emp_rsa 
                                         WHERE commission_pct IS NULL
                                         ORDER BY salary)
                                   WHERE ROWNUM <=5)
    RETURNING employee_id, first_name, last_name, email, phone_number, hire_date, job_id, 
    salary, commission_pct, manager_id, department_id 
    BULK COLLECT INTO t;
    FOR i IN 1..5 LOOP
         IF t.EXISTS(i) THEN 
            DBMS_OUTPUT.PUT('Cod angajat: ' || t(i).employee_id 
                            || ', Salariu nou: ' || t(i).salary);
            DBMS_OUTPUT.NEW_LINE;
         END IF;
    END LOOP;
ROLLBACK;
END;    