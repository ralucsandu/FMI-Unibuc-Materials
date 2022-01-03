--ex7a)
--Câte exemplare au statusul eronat? 

select count(*) "Nr exemplare cu status eronat"
from (select t.title, tc.copy_id, status, case  
  when (t.title_id, tc.copy_id) not in (select title_id, copy_id from rental where act_ret_date is null)  
    then 'AVAILABLE'  
  else 'RENTED'  
end "STATUS CORECT"  
from title_rsa t, title_copy_rsa tc where t.title_id = tc.title_id) 
where status != "STATUS CORECT"; 

--ex7b)
--Setati statusul corect pentru toate exemplarele care au statusul eronat. Salvati actualizarile realizate.
update title_copy_rsa
set status =(case 
    when (title_id, copy_id) not in (select title_id, copy_id from rental where act_ret_date is null)  
        then 'AVAILABLE'  
    else 'RENTED' 
end);
commit;
select * from title_copy_rsa;

--ex8. Toate filmele rezervate au fost împrumutate la data rezervarii? 
--Afisati textul "Da" sau "Nu" în functie de situatie.

select case 
when (select count(*) 
      from rental_rsa r1 
      join reservation_rsa r2 on (r1.member_id=r2.member_id and r1.title_id=r2.title_id)
      where book_date <> res_date)>0
    then 'Nu' 
    else 'Da' 
    end "S-a respectat data rezervarii?"
from dual;

--ex9. De câte ori a împrumutat un membru (nume si prenume) fiecare film (titlu)?

--afisam toate numele si filmele, chiar daca numarul de inchirieri este zero. 
select m.last_name as "Nume", m.first_name as "Prenume", t.title as "Titlu film",
       (select count(*)
        from rental_rsa r
        where r.title_id = t.title_id and r.member_id = m.member_id) "Nr de imprumuturi"
from member_rsa m, title_rsa t
order by m.first_name;

--ex10. De câte ori a împrumutat un membru (nume si prenume) fiecare exemplar (cod) al unui film (titlu)? 

select m.last_name as "Nume", m.first_name as "Prenume", t.title as "Titlu film", tc.copy_id as "Cod",
    (select count(*)
     from rental_rsa r
     where r.title_id = t.title_id and r.member_id = m.member_id and r.copy_id = tc.copy_id) "Nr de imprumuturi"
from member_rsa m, title_rsa t join title_copy_rsa tc on (t.title_id = tc.title_id)
order by m.first_name;

--ex11. Obtineti statusul celui mai des împrumutat exemplar al fiecarui film (titlu).

select t.title as "Titlu film", tc.status as "Status film", tc.copy_id as "Cod exemplar", count(*) as "Nr max imprumuturi"
from title_rsa t join title_copy_rsa tc on (t.title_id = tc.title_id)
                 join rental_rsa r on (r.title_id = t.title_id and r.copy_id = tc.copy_id)
group by t.title, tc.status, tc.copy_id, t.title_id
having count(*) = (select max(count(*))
                   from title_copy_rsa tcc join rental_rsa rr on (tcc.copy_id = rr.copy_id and tcc.title_id = rr.title_id)
                   where tcc.title_id = t.title_id
                   group by tcc.copy_id, tcc.status, tcc.title_id);

--ex12. Pentru anumite zile specificate din luna curenta, obtineti numarul de împrumuturi efectuate.

--subcerere pentru a obtine toate zilele din luna curenta
select trunc(last_day(sysdate)- rownum + 1)
from dual 
connect by rownum < 32 

--a.Se iau în considerare doar primele 2 zile din luna.

select data_ceruta, (select count(*) from rental_rsa where extract(day from book_date) = extract(day from data_ceruta) and
                                                           extract(month from book_date) = extract(month from data_ceruta) and
                                                           extract(year from book_date) = extract(year from data_ceruta)) as "Nr de imprumuturi"
from (select trunc(last_day(sysdate)- rownum + 1) data_ceruta
      from dual 
      connect by rownum < 32) 
where data_ceruta >= trunc(sysdate, 'mm') and extract(day from data_ceruta) in (1,2)
order by data_ceruta;

--b.  Se iau în considerare doar zilele din luna în care au fost efectuate împrumuturi.

select to_char(book_date, 'DD-MM-YYYY'), count(*) as "Nr imprumuturi"
from rental_rsa 
--where extract(month from book_date) = extract(month from sysdate) - 1 and
--      extract(year from book_date) = extract(year from sysdate)    --nu functioneaza pentru luna ianuarie
where to_char(book_date, 'MM-YYYY') = to_char(add_months(sysdate, -1), 'MM-YYYY')
group by to_char(book_date, 'DD-MM-YYYY'); 

--test pe cazul cu ianuarie 
select to_char(book_date, 'DD-MM-YYYY'), count(*) as "Nr imprumuturi"
from rental_rsa 
--where extract(month from book_date) = extract(month from sysdate) - 1 and
--      extract(year from book_date) = extract(year from sysdate)    --nu functioneaza pentru luna ianuarie
where to_char(book_date, 'MM-YYYY') = to_char(add_months('03-JAN-2021', -1), 'MM-YYYY')
group by to_char(book_date, 'DD-MM-YYYY'); 

select to_char(book_date, 'DD-MM-YYYY HH:MI:SS')
from rental
order by book_date;

select * from rental_rsa; 

insert into rental_rsa values (to_date('27-sep-2020 06:32:59', 'DD-MON-YYYY HH:MI:SS'), 1, 101, 93, null, '28-sep-2021');
insert into rental_rsa values (to_date('27-sep-2021 06:31:57', 'DD-MON-YYYY HH:MI:SS'), 1, 101, 93, null, '28-sep-2021');
insert into rental_rsa values (to_date('27-dec-2020 06:21:57', 'DD-MON-YYYY HH:MI:SS'), 1, 102, 93, null, '28-sep-2021');

--c. Se iau în considerare toate zilele din luna, incluzând în rezultat si zilele în care nu au fost efectuate împrumuturi

select data_ceruta, (select count(*) from rental_rsa where extract(day from book_date) = extract(day from data_ceruta) and
                                                           extract(month from book_date) = extract(month from data_ceruta) and
                                                           extract(year from book_date) = extract(year from data_ceruta)) as "Nr de imprumuturi"
from (select trunc(last_day(sysdate)- rownum + 1) data_ceruta
      from dual 
      connect by rownum < 32)
where data_ceruta >=trunc(sysdate, 'mm')
order by data_ceruta;