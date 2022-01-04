--11
create table emp_rsa as select * from employees;
select * from emp_rsa;
--12
COMMENT ON TABLE emp_rsa IS 'Informaţii despre angajati';
select * from user_tab_comments where table_name='EMP_RSA';
--13
select sysdate from dual;
ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY HH:MI:SS';
--14
SELECT EXTRACT(year FROM SYSDATE)"Anul curent"
FROM dual;
--15
select extract(DAY FROM SYSDATE)"Ziua curenta", extract(MONTH FROM SYSDATE)"Luna curenta" FROM dual;
--16
create table job_grades_rsa as select * from job_grades;
create table job_history_rsa as select * from job_history;
create table jobs_rsa as select * from jobs;
create table locations_rsa as select * from locations;
create table member_rsa as select * from member;
create table projects_rsa as select * from projects;
create table regions_rsa as select * from regions;
create table rental_rsa as select * from rental;
create table reservation_rsa as select * from reservation;
create table title_rsa as select * from title;
create table title_copy_rsa as select * from title_copy;
create table work_rsa as select * from work;
select * from user_tables
where table_name like '%_RSA';

