--20
--Rezultatul comenzii SET FEEDBACK OFF va fi stergerea mesajului despre cate linii au fost selectate, in cazul nostru
--"13 rows selected". Pentru a anula aceasta comanda, folosim SET FEEDBACK ON. 

--21
--Comanda SET PAGESIZE 0 elimina toate informatiile ce ajuta la formatare si organizare
SET FEEDBACK ON;
SET PAGESIZE 0;
spool 'd:/script_stergere2.sql' replace
SELECT 'DROP TABLE ' || table_name || ';' "EXERCITIU"
FROM   user_tables
WHERE  table_name LIKE upper('%_rsa');
spool off;

--22
--Un caz in care executia acestui script va determina erori este acela in care un tabel care se doreste a fi sters 
--nu exista in baza de date. Pentru a rezolva acest caz, trebuie sa verificam intai daca tabelele exista, si abia apoi 
--sa dam drop table. (drop table if exists table_name)

--23
spool 'd:/script_inserare.sql' replace
select 'insert into departments (department_id, department_name, location_id) values(' || department_id || 
', ' || department_name || ', ' || location_id || ');'
from departments;
spool off;