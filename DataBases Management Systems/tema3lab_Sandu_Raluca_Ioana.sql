--Tema 3 SGBD
--Realizata de: Sandu Raluca-Ioana
--Grupa : 242

--ex1. Se da urmatorul bloc:

DECLARE
numar number(3):=100;
mesaj1 varchar2(255):='text 1';
mesaj2 varchar2(255):='text 2';
BEGIN
    DECLARE
        numar number(3):=1;
        mesaj1 varchar2(255):='text 2';
        mesaj2 varchar2(255):='text 3';
    BEGIN
        numar:=numar+1;
        mesaj2:=mesaj2||' adaugat in sub-bloc';
        DBMS_OUTPUT.PUT_LINE(numar);
        DBMS_OUTPUT.PUT_LINE(mesaj1);
        DBMS_OUTPUT.PUT_LINE(mesaj2);
    END;
numar:=numar+1;
mesaj1:=mesaj1||' adaugat un blocul principal';
mesaj2:=mesaj2||' adaugat in blocul principal'; 
DBMS_OUTPUT.PUT_LINE(numar);
DBMS_OUTPUT.PUT_LINE(mesaj1);
DBMS_OUTPUT.PUT_LINE(mesaj2);
END;

--a) Valoarea variabilei numar în subbloc este: 2
--b) Valoarea variabilei mesaj1 în subbloc este: 'text 2'
--c) Valoarea variabilei mesaj2 în subbloc este: 'text 3 adaugat in sub-bloc'
--d) Valoarea variabilei numar în bloc este: 101
--e) Valoarea variabilei mesaj1 în bloc este: 'text 1 adaugat un blocul principal'
--f) Valoarea variabilei mesaj2 în bloc este: 'text 2 adaugat in blocul principal'

--ex2. 
--Se da urmatorul enunt: Pentru fiecare zi a lunii octombrie (se vor lua în considerare si zilele din 
--luna în care nu au fost realizate împrumuturi) obtineti numarul de împrumuturi efectuate.
--a. Încercati sa rezolvati problema în SQL fara a folosi structuri ajutatoare.
--b. Definiti tabelul octombrie_*** (id, data). Folosind PL/SQL populati cu date acest tabel. 

--a)
select trunc(last_day(add_months(sysdate,0))-rownum+1) data_ceruta
      from dual 
      connect by rownum <32 
      and trunc(last_day(add_months(sysdate,0))-rownum+1) >= trunc(add_months(sysdate, 0), 'MM');
      
--Rezolvare
select data_ceruta, (select count(*)
                     from rental_rsa where extract(year from book_date) = extract(year from data_ceruta) and
                                    extract(month from book_date) = extract(month from data_ceruta) and
                                    extract(day from book_date) = extract(day from data_ceruta)
                     ) as "Nr de imprumuturi"
from (select trunc(last_day(add_months(sysdate,0))-rownum+1) data_ceruta
      from dual 
      connect by rownum <32 
      and trunc(last_day(add_months(sysdate,0))-rownum+1) >= trunc(add_months(sysdate, 0), 'MM'));

      
--b)
--var 1
create table octombrie_rsa(id_data number(10), data_oct date);
DECLARE
    id_data number(2) := 0;
    data_oct date;
    maxim number(2) := extract(day from last_day(sysdate))-1;
BEGIN
    LOOP
        data_oct := to_date('01-OCT-2021') + id_data; 
        insert into octombrie_rsa values (id_data, data_oct);
        id_data := id_data + 1;
        exit when id_data > maxim;
    END LOOP;
END;

select * from octombrie_rsa    

--var2
create table octombrie_rsa2(id_data2 number(10), data_oct2 date);
DECLARE 
    id_data2 number(2) :=0;
    data_oct2 date;
BEGIN 
    FOR id_data2 in 1..31 LOOP
    data_oct2 := to_date(to_date('01-OCT-2021') + id_data2 - 1);
    insert into octombrie_rsa2 values (id_data2, data_oct2);
    END LOOP;
END;

select * from octombrie_rsa2