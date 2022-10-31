--Tema curs SGBD saptamana 7
--Realizata de: Sandu Raluca-Ioana
--Grupa: 242

--ex1.
--Pentru fiecare membru (nume + prenume), obtineti lista datelor imprumuturilor facute(book_date), precum si datele 
--la care trebuie sa returneze filmele(exp_ret_date). Incrementati un contor pentru fiecare imprumut facut, pe care 
--sa il restartati pentru fiecare membru. Tratati cazul cand un membru nu a efectuat niciun imprumut!

--2 cursoare, unul clasic si unul parametrizat
DECLARE 
    membru_aux MEMBER%ROWTYPE;
    imprumut_aux RENTAL%ROWTYPE;
    nr_impr NUMBER;
    CURSOR membru IS
        SELECT * 
        FROM member;
    CURSOR rezervare (parametru VARCHAR2) IS
        SELECT *
        FROM rental r
        WHERE r.member_id = parametru; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('------CURSOR CLASIC+CURSOR PARAMETRIZAT------');
    OPEN MEMBRU;
    LOOP
        FETCH MEMBRU INTO membru_aux;
        EXIT WHEN MEMBRU%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Membru: ' || membru_aux.last_name || ' ' || membru_aux.first_name);
        OPEN REZERVARE(membru_aux.member_id);
        nr_impr :=0;
        LOOP
            FETCH REZERVARE INTO imprumut_aux;
            EXIT WHEN REZERVARE%NOTFOUND;
            nr_impr:=nr_impr+1;
            DBMS_OUTPUT.PUT_LINE('  '||nr_impr||'.  '|| 'Data imprumut: ' || imprumut_aux.book_date ||
                                 ' | ' ||'Data expirare imprumut: ' || imprumut_aux.exp_ret_date);
        END LOOP;
        CLOSE REZERVARE;
    IF nr_impr=0 THEN
        DBMS_OUTPUT.PUT_LINE('  Membrul curent nu a efectuat niciun imprumut!');
    END IF;
    END LOOP;
    CLOSE MEMBRU;
END;
/
--2 ciclu cursoare fara subcereri
DECLARE     
    membru_aux MEMBER%ROWTYPE;
    imprumut_aux RENTAL%ROWTYPE;
    nr_impr NUMBER;
    CURSOR membru IS
        SELECT * 
        FROM member;
    CURSOR rezervare (parametru VARCHAR2) IS
        SELECT *
        FROM rental r
        WHERE r.member_id = parametru; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('------CICLU CURSOARE FARA SUBCERERI------');
    FOR membru_aux IN MEMBRU LOOP
        DBMS_OUTPUT.PUT_LINE('Membru: ' || membru_aux.last_name || ' ' || membru_aux.first_name);
    nr_impr := 0;   
    FOR imprumut_aux IN REZERVARE(membru_aux.member_id) LOOP
            nr_impr := nr_impr + 1;
            DBMS_OUTPUT.PUT_LINE('  '||nr_impr||'.  '|| 'Data imprumut: ' || imprumut_aux.book_date ||
                                 ' | ' ||'Data expirare imprumut: ' || imprumut_aux.exp_ret_date);
        END LOOP;
        IF nr_impr = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  Membrul curent nu a efectuat niciun imprumut!');
        END IF;
    END LOOP;
END;
/
--2 ciclu cursoare cu subcereri
DECLARE
    nr_impr NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('------CICLU CURSOARE CU SUBCERERI------');
    FOR membru_aux IN 
            (SELECT *
             FROM member) LOOP
        DBMS_OUTPUT.PUT_LINE('Membru: ' || membru_aux.last_name || ' ' || membru_aux.first_name);
        nr_impr := 0;
        FOR imprumut_aux IN 
            (SELECT *
             FROM rental r
             WHERE r.member_id = membru_aux.member_id) LOOP
            nr_impr := nr_impr + 1;
            DBMS_OUTPUT.PUT_LINE('  '||nr_impr||'.  '|| 'Data imprumut: ' || imprumut_aux.book_date ||
                                 ' | ' ||'Data expirare imprumut: ' || imprumut_aux.exp_ret_date);
        END LOOP;
        IF nr_impr = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  Membrul curent nu a efectuat niciun imprumut!');
        END IF;
    END LOOP;
END;
/
--2 expresii cursor 
DECLARE 
    TYPE refcursor IS REF CURSOR;
    CURSOR MEMBRU IS 
            (SELECT m.last_name, m.first_name, CURSOR (SELECT *
                                                       FROM rental r
                                                       WHERE r.member_id = m.member_id)
             FROM member m);
    membru_nume_aux VARCHAR2(200);
    membru_prenume_aux VARCHAR2(200);
    imprumut_aux rental%ROWTYPE;
    nr_impr NUMBER;
    v_cursor refcursor;
BEGIN
    DBMS_OUTPUT.PUT_LINE('------EXPRESII CURSOR------');
    OPEN MEMBRU;
    LOOP
        FETCH MEMBRU INTO membru_nume_aux, membru_prenume_aux, v_cursor;
        EXIT WHEN MEMBRU%NOTFOUND;  
        DBMS_OUTPUT.PUT_LINE('Membru: ' || membru_nume_aux ||' '|| membru_prenume_aux);
        nr_impr := 0; 
        LOOP
            FETCH v_cursor INTO imprumut_aux;
            EXIT WHEN v_cursor%NOTFOUND;
     
            nr_impr := nr_impr + 1;
            DBMS_OUTPUT.PUT_LINE('  '||nr_impr||'.  '|| 'Data imprumut: ' || imprumut_aux.book_date ||
                                 ' | ' ||'Data expirare imprumut: ' || imprumut_aux.exp_ret_date);
        END LOOP;
        IF nr_impr = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  Membrul curent nu a efectuat niciun imprumut!');
        END IF;
    END LOOP;
    CLOSE MEMBRU;
END;
/

--ex2.
--sesiunea 1
SELECT * FROM member_rsa 
WHERE member_id >=106 and member_id <=109 FOR UPDATE;
--ruland acest select, vom obtine membrii cu id-urile 106,107,108,109, alaturi de 
--informatiile aferente lor din tabelul member_rsa. 
--COMMIT;
