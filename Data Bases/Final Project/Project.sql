--10. crearea tabelelor 

CREATE TABLE LOC_MUNCA
(id_job number(5) constraint pkey_job primary key,
 nume_job varchar2(30) NOT NULL,
 salariu_minim number(5),
 salariu_maxim number(5)
 );
 
CREATE TABLE UTILIZATOR
(id_utilizator number(5) constraint pkey_user primary key,
 id_job number(5), foreign key(id_job) references LOC_MUNCA(id_job),
 username varchar2(25) NOT NULL,
 unique(username),
 parola varchar2(25) NOT NULL,
 unique(parola),
 tip_utilizator varchar2(20) NOT NULL, 
 data_angajare date,
 salariu number(5),
 nr_grupuri number(2)
);

CREATE TABLE FRIEND_REQUEST
(id_prieten number(5),
 id_utilizator number(5),
 data_imprietenire date default sysdate,
 constraint pkey_FR  primary key(id_prieten, id_utilizator),
 constraint fkey_FR1 foreign key(id_prieten) REFERENCES UTILIZATOR(id_utilizator),
 constraint fkey_FR2 foreign key(id_utilizator) REFERENCES UTILIZATOR(id_utilizator)
 );
ALTER TABLE FRIEND_REQUEST
ADD CONSTRAINT diff CHECK (id_prieten <> id_utilizator);

 
CREATE TABLE PROFIL
(id_profil number(5) constraint pkey_profil primary key,
 id_utilizator number(5), 
 foreign key(id_utilizator) references UTILIZATOR(id_utilizator),
 unique(id_utilizator),
 nume varchar2(25) constraint nume_user NOT NULL,
 prenume varchar2(25) constraint prenume_user NOT NULL,
 email varchar(50),
 unique (email),
 data_nastere date,
 sex char(1),
 nr_telefon char(15), 
 unique(nr_telefon)
 );
 
CREATE TABLE GRUP
(id_grup number(5) constraint pkey_gr primary key,
 denumire varchar(50),
 data_creare date default sysdate
 );
ADD id_utilizator number(5) constraint 
CREATE TABLE ANUNT 
(id_anunt number(5) constraint pkey_anunt primary key,
 data_anunt date default sysdate
);

CREATE TABLE SCRIE
(id_utilizator number(5),
 id_anunt number(5),
 id_grup number(5),
 constraint pkey_scrie primary key(id_utilizator, id_anunt, id_grup)
 );
ALTER TABLE SCRIE
ADD CONSTRAINT fkey_scrie1 FOREIGN KEY (id_utilizator) REFERENCES UTILIZATOR(id_utilizator);
ALTER TABLE SCRIE
ADD CONSTRAINT fkey_scrie2 FOREIGN KEY (id_anunt) REFERENCES ANUNT(id_anunt);
ALTER TABLE SCRIE
ADD CONSTRAINT fkey_scrie3 FOREIGN KEY (id_grup) REFERENCES GRUP(id_grup);

CREATE TABLE CATEGORIE
(id_categorie number(5) constraint pkey_categ primary key,
 nume_categorie varchar2(20)
 );

CREATE TABLE POSTARE
(id_postare number(5) constraint pkey_post primary key,
 id_categorie number(5), foreign key (id_categorie) REFERENCES CATEGORIE (id_categorie),
 id_utilizator number(5), foreign key(id_utilizator) REFERENCES UTILIZATOR(id_utilizator),
 data_postare date default sysdate,
 continut varchar2(500),
 nr_likeuri number(6),
 nr_shareuri number(6),
 nr_comentarii number(6)
 );

CREATE TABLE COMENTARIU
(id_comentariu number(5) constraint pkey_comm primary key,
 id_utilizator number(5),
 foreign key(id_utilizator) references UTILIZATOR(id_utilizator),
 id_postare number(5),
 foreign key(id_postare) references POSTARE(id_postare)
 );
 
CREATE TABLE APRECIERE
(id_like number(5) constraint pkey_like primary key,
 id_utilizator number(5),
 foreign key(id_utilizator) references UTILIZATOR(id_utilizator),
 unique(id_utilizator),
 id_postare number(5),
 foreign key(id_postare) references POSTARE(id_postare),
 unique(id_postare)
 );
 
CREATE TABLE DISTRIBUIRE
 (id_share number(5) constraint pkey_share primary key,
  id_utilizator number(5),
  foreign key(id_utilizator) references UTILIZATOR(id_utilizator),
  id_postare number(5),
  foreign key(id_postare) references POSTARE(id_postare)
  );

--inserarea datelor in tabel

INSERT INTO ANUNT VALUES(1, sysdate); 
INSERT INTO ANUNT VALUES(2, to_date('12-05-2021', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(3, to_date('20-02-2020', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(4, to_date('01-05-2017', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(5, to_date('27-11-2020', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(6, to_date('31-03-2010', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(7, to_date('15-05-2021', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(8, to_date('01-01-2021', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(9, to_date('06-12-2019', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(10, to_date('25-12-2009', 'dd-mm-yyyy')); 

INSERT INTO GRUP VALUES(10, 'ANUNTURI PUBLICITARE',  to_date('13-02-2010', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(20, 'COLEGIUL NATIONAL VASILE ALECSANDRI',  to_date('04-04-2018', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(30, 'SKINCARE ROUTINES',  to_date('07-12-2017', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(40, 'GRUPUL SOFERILOR DIN ROMANIA',  to_date('17-12-2017', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(50, 'ANUNTURI JOBURI',  to_date('20-07-2013', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(60, 'TEME SI MATERIALE PENTRU EXAMEN',  to_date('01-10-2016', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(70, 'FMI-SERIA 14 INFORMATICA',  to_date('01-10-2016', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(80, 'INTREBARI DE IT',  to_date('30-11-2020', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(90, 'CONFESIUNI',  to_date('31-05-2021', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(100, 'RETETE CULINARE',  to_date('15-04-2008', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(110, 'ARTICOLE DE VANZARE SH', SYSDATE);

INSERT INTO CATEGORIE VALUES(23, 'DIVERTISMENT');
INSERT INTO CATEGORIE VALUES(34, 'SPORT');
INSERT INTO CATEGORIE VALUES(55, 'MUZICA');
INSERT INTO CATEGORIE VALUES(15, 'JOCURI VIDEO');
INSERT INTO CATEGORIE VALUES(29, 'FILME SI SERIALE');
INSERT INTO CATEGORIE VALUES(444, 'LECTURA');
INSERT INTO CATEGORIE VALUES(356, 'MEDICINA');
INSERT INTO CATEGORIE VALUES(214, 'ANIMALE');
INSERT INTO CATEGORIE VALUES(98, 'STIRI SI POLITICA');
INSERT INTO CATEGORIE VALUES(123, 'STIINTA');
INSERT INTO CATEGORIE VALUES(785, 'AUTOMOBILE');
INSERT INTO CATEGORIE VALUES(61, 'CALATORII');
INSERT INTO CATEGORIE VALUES(83, 'MATEMATICA');
INSERT INTO CATEGORIE VALUES(178, 'BEAUTY');

 INSERT INTO LOC_MUNCA VALUES(0, 'programator', 2300, 50000);
 INSERT INTO LOC_MUNCA VALUES(1, 'economist', 1800, 6643);
 INSERT INTO LOC_MUNCA VALUES(2, 'analist date', 2010, 9983);
 INSERT INTO LOC_MUNCA VALUES(3, 'web designer', 3403, 89320);
 INSERT INTO LOC_MUNCA VALUES(4, 'contabil', 1678, 9992); 
 INSERT INTO LOC_MUNCA VALUES(5, 'profesor', 2000, 5567);
 INSERT INTO LOC_MUNCA VALUES(6, 'game tester', 2556, 10234);
 INSERT INTO LOC_MUNCA VALUES(7, 'Hr recruiter', 3040, 12000);
 INSERT INTO LOC_MUNCA VALUES(8, 'psiholog', 1555, 8300);
 INSERT INTO LOC_MUNCA VALUES(9, 'doctor', 4000, 20050);
 
--creare de secvente

 CREATE SEQUENCE SEQ_USER
 INCREMENT BY 1
 START WITH 100
 MAXVALUE 200
 NOCYCLE;
 
 CREATE SEQUENCE SEQ_PROFILE
 INCREMENT BY 1
 START WITH 200
 MAXVALUE 2000
 NOCYCLE;
 
 CREATE SEQUENCE SEQ_POST
 INCREMENT BY 5
 START WITH 300
 MAXVALUE 1000
 NOCYCLE;

 CREATE SEQUENCE SEQ_COMM
 INCREMENT BY 1
 START WITH 250
 MAXVALUE 300
 NOCYCLE;
 
 CREATE SEQUENCE SEQ_LIKE
 INCREMENT BY 1
 START WITH 360
 MAXVALUE 400
 NOCYCLE;
 
CREATE SEQUENCE SEQ_SHARE
INCREMENT BY 1
START WITH 450
MAXVALUE 500
NOCYCLE;

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 0, 'raluki', 'iepure123', 'utilizator', to_date('25-12-2020', 'dd-mm-yyyy'), 2700, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL, 'Sandu', 'Raluca', 'raluca.sandu5@s.unibuc.ro', to_date('01-04-2001', 'dd-mm-yyyy'), 'F', '0749259300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 23, SEQ_USER.CURRVAL, sysdate, '-Ce i-a spus 0 lui 8? Ce curea smechera ai!', 4, 1, null);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL,3, 'dimplays', 'i3banana', 'admin_grup', to_date('25-12-2020', 'dd-mm-yyyy'), 3500, 3);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL, 'Dima', 'Viorel', 'dimplays@yahoo.com', to_date('27-11-2000', 'dd-mm-yyyy'), 'M', '0752793015');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 34, SEQ_USER.CURRVAL, to_date('01-04-2021', 'dd-mm-yyyy'), 'Atletico Madrid - Real Sociedad 2-1. Trupa lui Simeone a facut un pas urias spre titlu, cu emotii pe final.', 154, 55, 500);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, null, 'ioneliap96', '59tin9t6', 'utilizator', null, null, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Popescu', 'Ionela', 'ionela_adriana@gmail.com', to_date('06-02-1996', 'dd-mm-yyyy'), 'F', '0759023001');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 55, SEQ_USER.CURRVAL, to_date('13-05-2021', 'dd-mm-yyyy'), 'Roxen a ajuns la Rotterdam pentru Eurovision, iar prima repetitie a starnit reactii puternice.', 12245, 222, 2000);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 6, 'anavlad', 'ieabsie033', 'utilizator', to_date('13-10-2017','dd-mm-yyyy'), 2350, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Vlad', 'Ana', 'vlayana@yahoo.com', to_date('01-04-2002', 'dd-mm-yyyy'), 'F', '0749123300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 15, SEQ_USER.CURRVAL, sysdate, '-Ce parere aveti despre Call Of Duty?', 1, null, 5);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 1,'unseen1022', 'abecedareeaa3', 'admin_grup', to_date('20-11-2017', 'dd-mm-yyyy'),6000, 20);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL, 'Stancu', 'Ionut', 'stancu.ionut8@s.unibuc.ro', to_date('12-10-1999', 'dd-mm-yyyy'), 'M', '0780059300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 29, SEQ_USER.CURRVAL, to_date('20-03-2021', 'dd-mm-yyyy'), 'Aflati de ce a urlat Frances McDormand ca un lup la gala Oscar 2021', 100, 50, 3);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, null, 'crissmarin', 'ajfdjksd', 'utilizator', null, null, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Marin', 'Cristiana', 'crissa123@gmail.com', to_date('24-02-2005', 'dd-mm-yyyy'), 'F', '0712389017');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 444, SEQ_USER.CURRVAL, to_date('18-02-2011', 'dd-mm-yyyy'), 'Sa o apreciem pe Agatha Christie, cea mai buna scriitoare de carti thriller', 1230, 80, 340);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 9, 'aurelmanole', 'ale02', 'admin_grup', to_date('11-05-2000', 'dd-mm-yyyy'), 20030, 4);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL , 'Manole', 'Aurelian', 'aureliusmano@yahoo.com', to_date('27-08-1965', 'dd-mm-yyyy'), 'M', '0749810300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 356, SEQ_USER.CURRVAL, sysdate, 'Plasma imbogatita in trombocite reprezinta o metoda naturala revolutionara care foloseste sangele propriu pentru a accelera vindecarea tesuturilor moi', 1, 2, 3);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 2, 'emlisaman', 'calorifercocacola', 'admin_grup', to_date('01-05-2021', 'dd-mm-yyyy'), 2340, 1);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Manole', 'Elisabeta', 'elisa.manole@s.unibuc.ro', to_date('08-08-2000', 'dd-mm-yyyy'), 'F', '0769229340');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 785, SEQ_USER.CURRVAL, to_date('27-08-2018', 'dd-mm-yyyy'), 'Tesla se pregateste sa lanseze un nou model!', 550, 300, 1500);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, null, 'eugen1234', 'popcornr33', 'utilizator',null,null, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL, 'Costin', 'Eugen', 'genicostinel@gmail.com', to_date('01-04-2001', 'dd-mm-yyyy'), 'M', '0749442300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 61, SEQ_USER.CURRVAL, sysdate, 'Am vizitat Egiptul luna trecuta. Trebuie neaparat sa mergeti acolo!', 25, null, null);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 8, 'dannyshere', '3r5t6y7u', 'utilizator', to_date('18-09-1999', 'dd-mm-yyyy'),7750, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Cireasa', 'Dan', 'dan_cireasa_65@yahoo.com', to_date('25-12-1967', 'dd-mm-yyyy'), 'M', '0779259651');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 98, SEQ_USER.CURRVAL, to_date('17-04-2019', 'dd-mm-yyyy'), '-Cine credeti ca este candidatul perfect pentru alegerile prezidentiale?', 25, 25, 100);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 7, 'ioanber', 'truestortuio', 'admin_grup', to_date('15-03-2014', 'dd-mm-yyyy'), 10050, 2);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Berescu', 'Ioan', 'ioanber@navrom.com', to_date('17-04-1993', 'dd-mm-yyyy'), 'M', '0732258306');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 214, SEQ_USER.CURRVAL, sysdate, 'Perusul meu este bolnav, i s-a uscat foarte tare ciocul. Aveti idee ce as putea face?', null, null, 5);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, null,'cazyteo', '9340anf', 'utilizator',null, null, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Cazamir', 'Teona', 'caza_teo@gmail.com', to_date('01-05-2003', 'dd-mm-yyyy'), 'F', '0721659400');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 123, SEQ_USER.CURRVAL, sysdate, 'In urma unui studiu, s-a constatat ca o zi dureaza mai mult decât un an pe planeta Venus', 1240, 730, 555);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL,4, 'dascaluIonica76', 'raresana0306', 'utilizator', to_date('12-01-1995', 'dd-mm-yyyy'), 6032, null);
INSERT INTO PROFIL VALUES (SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Dascalu', 'Ionica', 'dascion@yahoo.com', to_date('05-03-1976', 'dd-mm-yyyy'), 'M', '0734805571');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL,1, 'liliMiuBuc', 'dr@gonbalk3j', 'admin_grup', to_date('20-02-1985', 'dd-mm-yyyy'),3500, 4);
INSERT INTO PROFIL VALUES (SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Miu', 'Liliana', 'lilica_miu@gmail.com', to_date('14-04-1966', 'dd-mm-yyyy'), 'F', '0735206574');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 0, 'damiansuhov', 'skizoamabsaosoe', 'utilizator',to_date('30-04-2021', 'dd-mm-yyyy'), 4800, null);
INSERT INTO PROFIL VALUES (SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Suhov', 'Damian', 'dam.suh@s.unibuc.ro', to_date('01-06-2001', 'dd-mm-yyyy'), 'M', '0785203571');

INSERT INTO POSTARE VALUES(360, 23, 102, to_date('13-09-2020', 'dd-mm-yyyy'), '-De ce a trecut varza strada? -Ca era verde!', 30, 30, 30);
INSERT INTO POSTARE VALUES(365, 23, 105, to_date('01-06-2019', 'dd-mm-yyyy'), '-De ce are rinocerul corn? -Fiindca nu a gasit paine!', 235, 20, null);
INSERT INTO POSTARE VALUES(370, 34, 109, to_date('15-10-2018', 'dd-mm-yyyy'), 'Simona Halep este o juc?toare de tenis din România care a atins prima pozi?ie în clasamentul mondial WTA, în dou? rânduri, între 2017 ?i 2019.', 1000, 550, 300);
INSERT INTO POSTARE VALUES(375, 23, 113, sysdate, '-Cum ob?ii lumina cu ajutorul apei? -Speli geamurile!',15, 2, 30);

INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 100, 305);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 100, 305);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 100, 325);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 103, 320);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 110, 325);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 102, 330);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 113, 305);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 114, 315);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 111, 315);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 112, 350);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 109, 325);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 107, 310);
INSERT INTO COMENTARIU VALUES(SEQ_COMM.NEXTVAL, 105, 345);

INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 100, 300);
INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 101, 305);
INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 102, 355);
INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 103, 330);
INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 111, 310);
INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 109, 345);
INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 106, 335);
INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 114, 340);
INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 110, 325);
INSERT INTO APRECIERE VALUES(SEQ_LIKE.NEXTVAL, 112, 315);

INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 100, 355);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 100, 345);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 101, 355);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 102, 300);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 110, 325);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 111, 335);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 109, 310);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 108, 330);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 112, 355);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 104, 320);
INSERT INTO DISTRIBUIRE VALUES(SEQ_SHARE.NEXTVAL, 113, 330);

INSERT INTO FRIEND_REQUEST VALUES(100, 101, sysdate);
INSERT INTO FRIEND_REQUEST VALUES(100, 102, to_date('01-05-2016', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(100, 103, to_date('11-06-2017', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(100, 104, to_date('12-08-2014', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(107, 102, to_date('25-12-2015', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(102, 103, to_date('14-02-2020', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(103, 104, to_date('15-02-2021', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(103, 107, to_date('09-05-2020', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(103, 112, to_date('01-04-2016', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(104, 110, to_date('02-02-2013', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(105, 107, to_date('06-01-2020', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(106, 107, to_date('09-04-2021', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(105, 114, sysdate);
INSERT INTO FRIEND_REQUEST VALUES(113, 114, to_date('15-07-2019', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(108, 111, to_date('19-11-2017', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(108, 113, to_date('29-08-2021', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(108, 109, to_date('30-05-2014', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(109, 111, to_date('06-06-2016', 'dd-mm-yyyy'));
INSERT INTO FRIEND_REQUEST VALUES(111, 113, sysdate);
INSERT INTO FRIEND_REQUEST VALUES(110, 113, sysdate);

select * from scrie; 
INSERT INTO SCRIE VALUES(101, 1, 10);
INSERT INTO SCRIE VALUES(104, 5, 20);
INSERT INTO SCRIE VALUES(106, 9, 100);
INSERT INTO SCRIE VALUES(107, 10, 30);
INSERT INTO SCRIE VALUES(110, 7, 40);
INSERT INTO SCRIE VALUES(110, 6, 50);
INSERT INTO SCRIE VALUES(113, 2, 80);
INSERT INTO SCRIE VALUES(107, 3, 70);
INSERT INTO SCRIE VALUES(115, 8, 20);
INSERT INTO SCRIE VALUES(104, 2, 10);
INSERT INTO SCRIE VALUES(106, 5, 90);
INSERT INTO SCRIE VALUES(107, 10, 50);
INSERT INTO SCRIE VALUES(101, 7, 20);
INSERT INTO SCRIE VALUES(101, 6, 50);
INSERT INTO SCRIE VALUES(101, 3, 40);
INSERT INTO SCRIE VALUES(110, 1, 10);
INSERT INTO SCRIE VALUES(107, 3, 50);
INSERT INTO SCRIE VALUES(115, 5, 60);

SELECT * FROM LOC_MUNCA;
SELECT * FROM PROFIL;
SELECT * FROM CATEGORIE;
SELECT * FROM GRUP;
SELECT * FROM ANUNT;

SELECT * FROM POSTARE; 
SELECT * FROM UTILIZATOR; 
SELECT * FROM PROFIL;

SELECT * FROM COMENTARIU;
SELECT * FROM APRECIERE; 
SELECT * FROM SCRIE;
SELECT * FROM DISTRIBUIRE;
SELECT * FROM FRIEND_REQUEST;

UPDATE utilizator
SET data_angajare = sysdate
WHERE id_utilizator = 115;

--CERERE 1: JOIN PE 4 TABELE SI ORDONARE CRESCATOARE
--Mai multi utilizatori de tip profesor posteaza postari. 
--Afisati username-ul, numele si prenumele(concatenat) profesorului angajat primul, 
--continutul postarii precum si numele categoriei in care se incadreaza. 
--Etichetati coloanele corespunzator si ordonati rezultatele crescator dupa data angajarii utilizatorilor.
SELECT continut "Continut postare", nume_categorie "Categorie", username "Nume utilizator", pr.nume||' '|| pr.prenume "Nume prenume", u.data_angajare "Data angajare"
FROM postare p, categorie c, utilizator u, loc_munca j, profil pr
WHERE p.id_categorie = c.id_categorie and 
      p.id_utilizator = u.id_utilizator and 
      u.id_job = j.id_job and 
      UPPER(nume_job) = 'PROFESOR' 
      and pr.id_utilizator = u.id_utilizator  
      order by u.data_angajare;

--ex 12 : 
--Stergeti din baza de date locul de munca care nu apartine niciunui utilizator din baza de date. Anulati modificarile.

DELETE FROM LOC_MUNCA
WHERE id_job in (SELECT id_job
                 FROM LOC_MUNCA
                 MINUS
                 SELECT id_job
                 FROM utilizator);
ROLLBACK;                

--Stergeti din baza de date categoria careia nu apartine nicio postare. Pastrati modificarile. 

DELETE FROM CATEGORIE
WHERE id_categorie in  (SELECT id_categorie
                        FROM categorie
                        MINUS
                        SELECT id_categorie
                        FROM postare);
COMMIT;

SELECT * FROM UTILIZATOR;

--Modificati salariul utilizatorului cu id-ul 107, astfel incat acesta sa castige cu 20% mai mult decat 
--media salariilor utilizatorilor din baza de date. Salvati modificarile!
UPDATE utilizator
SET salariu = (SELECT round(avg(salariu)) * 1.2
               FROM utilizator)
WHERE id_utilizator = 107;

commit;

--CERERE 1: 
---CASE + functia months_between pentru date calendaristice + 
---functia length pentru siruri de caractere + ordonare descrescatoare
--Sa se afiseze pentru fiecare postare data la care a fost scrisa, precum si rata popularitatii acesteia.
--Daca postarea are peste 1000 de aprecieri, atunci ea este considerata populara, daca are mai mult de 10 aprecieri si
--mai putin de 1000, atunci ea se condiera cunoscuta, iar in rest, se considera necunoscuta. Se vor afisa doar postarile
--mai vechi de un an. 

SELECT continut,data_postare ,
CASE 
   WHEN nr_likeuri>1000 THEN 'Postare populara'
   WHEN nr_likeuri<1000 and nr_likeuri > 10 THEN 'Postare cunoscuta'
   ELSE 'Postare necunoscuta' END as "RATA POPULARITATE"
   FROM postare WHERE (nr_likeuri is not null) and round(months_between(sysdate, data_postare))>=12 
   ORDER by length(continut) desc;

--CERERE 2: 
-------functie pe DATA CALENDARISTICA pentru a afisa luna + 
-------JOIN pe 4 tabele + SUBCERERE NESINCRONIZATA  + functia LOWER pentru siruri de caractere
--Sa se afiseze codul, luna in care a fost postata, categoria de care apartine si continutul pentru postarea publicata
--de utilizatorul care lucreaza ca programator. 
--Afisati, de asemenea, numele, prenumele si username-ul acestui utilizator.  

SELECT id_postare, to_char(data_postare, 'MON') "LUNA", nume_categorie, continut, 
        username "NUME UTILIZATOR", prf.nume||' '||prf.prenume "NUME PRENUME"
FROM postare p, categorie c, profil prf, utilizator u
WHERE (p.id_categorie = c.id_categorie)AND 
      (p.id_utilizator = u.id_utilizator)AND
      (prf.id_utilizator = u.id_utilizator)AND 
      (u.id_utilizator in (SELECT id_utilizator 
                           FROM utilizator
                           WHERE id_job = (SELECT id_job
                                           FROM loc_munca
                                           WHERE lower(nume_job) = 'programator')));


select * from loc_munca;
select * from utilizator

INSERT INTO UTILIZATOR VALUES(115, 8, 'moscuuteodoraa', 'imiplacesacant1234', 'admin_grup', sysdate, null, null);
INSERT INTO PROFIL VALUES(215, 115, 'Moscu', 'Teodora', 'moscuteo@gmail.com', to_date('13-09-2000', 'dd-mm-yyyy'), 'F', '0762118954');
--utilizatorul are NULL in coloana pentru salariu deoarece abia a fost angajat si nu i se cunoaste inca salariul
--am introdus aceasta coloana pentru a verifica faptul ca se afiseaza 0 in coloana pentru SALARIU MAJORAT in cazul in care
--nu se cunoaste salariul utilizatorului

--CERERE 3:
----DECODE + ordonare descrescatoare + conversia unui string in data calendaristica +
----NVL + JOIN pe 3 tabele + functiile UPPER si LOWER
--Sa se afiseaze numele, prenume, data angajarii(in ordine descrescatoare), salariul initial, precum si salariul dupa majorare
--pentru utilizatorii angajati inainte de inceputul anului 2021, 
--care muncesc drept programatori, economisti sau psihologi, stiind ca: 
--programatorilor le-a fost marit salariul cu 50%, economistilor cu 20%, iar psihologilor cu 25%. 
SELECT p.nume, p.prenume,u.data_angajare,j.nume_job, NVL(u.salariu,0) "SALARIU INAINTE DE MAJORARE", 
DECODE (lower(j.nume_job), 'programator', NVL(salariu + 0.5*salariu,0 ),
                           'economist',   NVL(salariu + 0.2*salariu, 0),
                           'psiholog',    NVL(1.25*salariu, 0)) "SALARIU DUPA MAJORARE"
FROM utilizator u, profil p, loc_munca j
WHERE (u.id_utilizator = p.id_utilizator)AND
      (u.id_job = j.id_job)AND
      (upper(j.nume_job) = 'PROGRAMATOR' or upper(j.nume_job) = 'ECONOMIST' or upper(j.nume_job) = 'PSIHOLOG')AND
       u.data_angajare<=to_date('01/01/2021','dd/mm/yyyy')
ORDER BY u.data_angajare desc;

--CERERE 4:
---JOIN pe 2 tabele, grupari de date, filtrare la nivel de grup, functii grup, subcerere nesincronizata

--Sa se afiseze codul, numele categoriei si numarul de postari aferente acesteia,
--pentru categoria din care fac parte cele mai multe postari. 

SELECT id_categorie, nume_categorie, count(id_postare) "NUMAR DE POSTARI AFERENTE"
FROM categorie JOIN postare USING (id_categorie)
GROUP BY id_categorie, nume_categorie
HAVING COUNT(id_postare) = (SELECT max(count(id_postare))
                            FROM postare
                            GROUP BY id_categorie);
                            
--CERERE 5:
---clauza WITH + JOIN + AVG + ROUND + functiile TRUNC si SYSDATE pentru date calendaristice + CONCAT
---COUNT(*) + filtrare la nivel de linie + ordonare crescatoare + SUBCERERI SINCRONIZATE

--Sa se afiseze informatiile despre utilizatorii care castiga mai putin decat media totala a salariilor din baza de date. 
--Veti afisa numele si prenumele, username-ul, parola, email-ul, numarul de telefon, data angajarii, salariul, locul de munca,
--numarul de zile de la angajare, salariul mediu al tuturor utilizatorilor cu acelasi loc de munca, 
--precum si numarul de utilizatori cu acelasi loc de munca. Ordonati rezultatele crescator dupa salariile utilizatorilor.
WITH AUX AS
           (SELECT avg(salariu) AS medie_totala_salarii
            FROM utilizator)
            
SELECT concat(concat(p.nume, ' '),p.prenume)"UTILIZATOR", username, parola,p.email, p.nr_telefon, data_angajare, salariu,
      (SELECT nume_job
       FROM loc_munca
       WHERE id_job = u.id_job) "LOC DE MUNCA",
       
      (SELECT trunc(sysdate) - u.data_angajare days FROM dual) "ZILE DE LA ANGAJARE",
      
      (SELECT round(avg(salariu))
       FROM utilizator 
       WHERE id_job = u.id_job) "SALARIU MEDIU PENTRU ACEST JOB",
       
      (SELECT count(*)
       FROM utilizator
       WHERE id_job = u.id_job) "NUMAR DE UTILIZATORI PE JOB"
      
       FROM utilizator u, aux a, profil p
       WHERE (u.salariu < a.medie_totala_salarii) AND (u.id_utilizator = p.id_utilizator)
       
ORDER BY salariu;


--EX16.
-----------------DIVISION
--CEREREA 1
--Sa se afiseze id-ul, username-ul si parola utilizatorilor care posteaza doar postari apartinand categoriei DIVERTISMENT.
SELECT p.id_utilizator, username, parola
FROM postare p JOIN utilizator u ON (p.id_utilizator = u.id_utilizator)
WHERE id_categorie in (SELECT id_categorie 
                       FROM categorie
                       WHERE nume_categorie = 'DIVERTISMENT')
GROUP BY p.id_utilizator, username, parola
HAVING count(*) = (SELECT count(id_categorie) 
                    FROM categorie
                    WHERE nume_categorie = 'DIVERTISMENT')                    
MINUS 
SELECT p.id_utilizator, username, parola
FROM postare p JOIN utilizator u ON (p.id_utilizator = u.id_utilizator)
WHERE id_categorie not in (SELECT id_categorie 
                                 FROM categorie
                                 WHERE nume_categorie = 'DIVERTISMENT');

SELECT * FROM SCRIE;

--CEREREA 2
--Sa se afiseze id-ul, username-ul si parola utilizatorilor care au scris un anunt in cel putin acelasi grup in care 
--a scris si utilizatorul cu id-ul 115. 
SELECT s.id_utilizator, username, parola
FROM scrie s JOIN utilizator u on (s.id_utilizator = u.id_utilizator)
WHERE id_grup in (SELECT id_grup
                  FROM scrie
                  WHERE id_utilizator = 115)
AND s.id_utilizator != 115
GROUP BY s.id_utilizator, username, parola
HAVING COUNT(*) = (SELECT COUNT(id_utilizator)
                   FROM scrie
                   WHERE id_utilizator = 115);

-----------------OUTER JOIN
--Sa se afiseze pentru fiecare utilizator care posteaza cel putin o postare, username-ul, locul de munca, 
--continutul postarii si categoria din care face parte postarea. Daca utilizatorul nu are job, se va afisa 
--in campul LOC DE MUNCA mesajul "fara job".

SELECT u.id_utilizator, u.username UTILIZATOR, NVL(j.nume_job, 'fara job') "LOC DE MUNCA", p.continut, c.nume_categorie 
FROM loc_munca j right outer join utilizator u on (u.id_job = j.id_job)
     right outer join postare p on (p.id_utilizator = u.id_utilizator)
     full outer join categorie c on(c.id_categorie = p.id_categorie);

select * from POSTARE
select * from utilizator
select * from loc_munca

--Sa se obtina data postarii apartinand categoriei DIVERTISMENT care a fost postata de utilizator al carui id_job este 0 

SELECT p.data_postare, p.continut
FROM postare p JOIN categorie c ON (p.id_categorie = c.id_categorie)
               JOIN utilizator u ON (p.id_utilizator = u.id_utilizator)
WHERE nume_categorie = 'DIVERTISMENT' AND u.id_job=0;

R1 = PROJECT (POSTARE, data_postare, continut, id_categorie, id_utilizator);
R2 = SELECT (CATEGORIE, nume_categorie = 'DIVERTISMENT);
R3 = PROJECT (R2, id_categorie)
R4 = SELECT (UTILIZATOR, id_job = 0);
R5 = PROJECT (R4, id_utilizator);
R6 = SEMIJOIN (R1, R3,  id_categorie);
R7 = SEMIJOIN (R6, R5, id_utilizator);
Rezultat = PROJECT(R7, data_postare, continut);

