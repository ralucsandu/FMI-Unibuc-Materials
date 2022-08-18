--DROP TABELE

DROP TABLE profil CASCADE CONSTRAINTS;
DROP TABLE utilizator CASCADE CONSTRAINTS;
DROP TABLE loc_munca CASCADE CONSTRAINTS;
DROP TABLE friend_request CASCADE CONSTRAINTS;
DROP TABLE scrie CASCADE CONSTRAINTS;
DROP TABLE anunt CASCADE CONSTRAINTS;
DROP TABLE grup CASCADE CONSTRAINTS;
DROP TABLE postare CASCADE CONSTRAINTS;
DROP TABLE categorie CASCADE CONSTRAINTS;
DROP TABLE comentariu CASCADE CONSTRAINTS;
DROP TABLE distribuire CASCADE CONSTRAINTS;
DROP TABLE apreciere CASCADE CONSTRAINTS;

--CREAREA TABELELOR

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
 salariu number(5)
);

CREATE TABLE FRIEND_REQUEST
(id_prieten number(5),
 id_utilizator number(5),
 data_imprietenire date default sysdate,
 constraint pkey_FR  primary key(id_prieten, id_utilizator),
 constraint fkey_FR1 foreign key(id_prieten) REFERENCES UTILIZATOR(id_utilizator),
 constraint fkey_FR2 foreign key(id_utilizator) REFERENCES UTILIZATOR(id_utilizator),
 constraint diff CHECK (id_prieten <> id_utilizator)
 );

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
 
CREATE TABLE ANUNT 
(id_anunt number(5) constraint pkey_anunt primary key,
 data_anunt date default sysdate
);

CREATE TABLE SCRIE
(id_utilizator number(5),
 id_anunt number(5),
 id_grup number(5),
 constraint pkey_scrie primary key(id_utilizator, id_anunt, id_grup),
 constraint fkey_scrie1 FOREIGN KEY (id_utilizator) REFERENCES UTILIZATOR(id_utilizator),
 constraint fkey_scrie2 FOREIGN KEY (id_anunt) REFERENCES ANUNT(id_anunt),
 constraint fkey_scrie3 FOREIGN KEY (id_grup) REFERENCES GRUP(id_grup)
 );

CREATE TABLE CATEGORIE
(id_categorie number(5) constraint pkey_categ primary key,
 nume_categorie varchar2(20)
 );


CREATE TABLE POSTARE
(id_postare number(5) constraint pkey_post primary key,
 id_categorie number(5), foreign key (id_categorie) REFERENCES CATEGORIE (id_categorie),
 id_utilizator number(5), foreign key(id_utilizator) REFERENCES UTILIZATOR(id_utilizator),
 data_postare date default sysdate,
 continut varchar2(500)
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
  foreign key(id_postare) references POSTARE(id_postare) );

--INSERAREA DATELOR IN TABELE

--ANUNT
INSERT INTO ANUNT VALUES(1, sysdate); 
INSERT INTO ANUNT VALUES(2, to_date('12-05-2021', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(3, to_date('20-02-2020', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(4, to_date('01-05-2017', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(5, to_date('27-11-2020', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(6, to_date('31-03-2010', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(7, to_date('15-05-2021', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(8, to_date('01-01-2021', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(9, to_date('06-12-2019', 'dd-mm-yyyy')); 
INSERT INTO ANUNT VALUES(10,to_date('25-12-2009', 'dd-mm-yyyy')); 

--GRUP
INSERT INTO GRUP VALUES(10, 'ANUNTURI PUBLICITARE',  to_date('13-02-2010', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(20, 'COLEGIUL NATIONAL VASILE ALECSANDRI',  to_date('04-04-2018', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(30, 'SKINCARE ROUTINES',  to_date('07-12-2017', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(40, 'GRUPUL SOFERILOR DIN ROMANIA',  to_date('17-12-2017', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(50, 'ANUNTURI JOBURI',  to_date('20-07-2013', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(60, 'TEME SI MATERIALE PENTRU EXAMEN',  to_date('01-10-2016', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(70, 'FMI-SERIA 24 INFORMATICA',  to_date('01-10-2016', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(80, 'INTREBARI DE IT',  to_date('30-11-2020', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(90, 'CONFESIUNI',  to_date('31-05-2021', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(100, 'RETETE CULINARE',  to_date('15-04-2008', 'dd-mm-yyyy'));
INSERT INTO GRUP VALUES(110, 'ARTICOLE DE VANZARE SH', SYSDATE);

--CATEGORIE
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

--LOC_MUNCA
INSERT INTO LOC_MUNCA VALUES(0, 'programator', 2300, 50000);
INSERT INTO LOC_MUNCA VALUES(1, 'economist', 1800, 6643);
INSERT INTO LOC_MUNCA VALUES(2, 'analist date', 2010, 9983);
INSERT INTO LOC_MUNCA VALUES(3, 'web designer', 3403, 89320);
INSERT INTO LOC_MUNCA VALUES(4, 'contabil', 1678, 9992); 
INSERT INTO LOC_MUNCA VALUES(5, 'profesor', 2000, 5567);
INSERT INTO LOC_MUNCA VALUES(6, 'game tester', 2556, 10234);
INSERT INTO LOC_MUNCA VALUES(7, 'hr recruiter', 3040, 12000);
INSERT INTO LOC_MUNCA VALUES(8, 'psiholog', 1555, 8300);
INSERT INTO LOC_MUNCA VALUES(9, 'doctor', 4000, 20050);


--INSERT FOLOSIND SECVENTA

--DROP LA SECVENTE
drop sequence seq_user;
drop sequence seq_profile;
drop sequence seq_post;
drop sequence seq_comm;
drop sequence seq_like;
drop sequence seq_share;

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

--UTILIZATOR, PROFIL, POSTARE
INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 0, 'raluki', 'iepure123', 'utilizator', to_date('25-12-2020', 'dd-mm-yyyy'), 2700);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL, 'Sandu', 'Raluca', 'raluca.sandu5@s.unibuc.ro', to_date('01-04-2001', 'dd-mm-yyyy'), 'F', '0749259300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 23, SEQ_USER.CURRVAL, sysdate, '-Ce i-a spus 0 lui 8? Ce curea smechera ai!');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL,3, 'dimplays', 'i3banana', 'admin_grup', to_date('25-12-2020', 'dd-mm-yyyy'), 3500);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL, 'Dima', 'Viorel', 'dimplays@yahoo.com', to_date('27-11-2000', 'dd-mm-yyyy'), 'M', '0752793015');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 34, SEQ_USER.CURRVAL, to_date('01-04-2021', 'dd-mm-yyyy'), 'Atletico Madrid - Real Sociedad 2-1. Trupa lui Simeone a facut un pas urias spre titlu, cu emotii pe final.');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, null, 'ioneliap96', '59tin9t6', 'utilizator', null, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Popescu', 'Ionela', 'ionela_adriana@gmail.com', to_date('06-02-1996', 'dd-mm-yyyy'), 'F', '0759023001');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 55, SEQ_USER.CURRVAL, to_date('13-05-2021', 'dd-mm-yyyy'), 'Roxen a ajuns la Rotterdam pentru Eurovision, iar prima repetitie a starnit reactii puternice.');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 6, 'anavlad', 'ieabsie033', 'utilizator', to_date('13-10-2017','dd-mm-yyyy'), 2350);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Vlad', 'Ana', 'vlayana@yahoo.com', to_date('01-04-2002', 'dd-mm-yyyy'), 'F', '0749123300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 15, SEQ_USER.CURRVAL, sysdate, '-Ce parere aveti despre Call Of Duty?');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 1,'unseen1022', 'abecedareeaa3', 'admin_grup', to_date('20-11-2017', 'dd-mm-yyyy'),6000);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL, 'Stancu', 'Ionut', 'stancu.ionut8@s.unibuc.ro', to_date('12-10-1999', 'dd-mm-yyyy'), 'M', '0780059300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 29, SEQ_USER.CURRVAL, to_date('20-03-2021', 'dd-mm-yyyy'), 'Aflati de ce a urlat Frances McDormand ca un lup la gala Oscar 2021');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, null, 'crissmarin', 'ajfdjksd', 'utilizator', null, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Marin', 'Cristiana', 'crissa123@gmail.com', to_date('24-02-2005', 'dd-mm-yyyy'), 'F', '0712389017');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 444, SEQ_USER.CURRVAL, to_date('18-02-2011', 'dd-mm-yyyy'), 'Sa o apreciem pe Agatha Christie, cea mai buna scriitoare de carti thriller');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 9, 'aurelmanole', 'ale02', 'admin_grup', to_date('11-05-2000', 'dd-mm-yyyy'), 20030);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL , 'Manole', 'Aurelian', 'aureliusmano@yahoo.com', to_date('27-08-1965', 'dd-mm-yyyy'), 'M', '0749810300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 356, SEQ_USER.CURRVAL, sysdate, 'Plasma imbogatita in trombocite reprezinta o metoda naturala revolutionara care foloseste sangele propriu pentru a accelera vindecarea tesuturilor moi');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 2, 'emlisaman', 'calorifercocacola', 'admin_grup', to_date('01-05-2021', 'dd-mm-yyyy'), 2340);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Manole', 'Elisabeta', 'elisa.manole@s.unibuc.ro', to_date('08-08-2000', 'dd-mm-yyyy'), 'F', '0769229340');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 785, SEQ_USER.CURRVAL, to_date('27-08-2018', 'dd-mm-yyyy'), 'Tesla se pregateste sa lanseze un nou model!');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, null, 'eugen1234', 'popcornr33', 'utilizator',null,null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL, 'Costin', 'Eugen', 'genicostinel@gmail.com', to_date('01-04-2001', 'dd-mm-yyyy'), 'M', '0749442300');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 61, SEQ_USER.CURRVAL, sysdate, 'Am vizitat Egiptul luna trecuta. Trebuie neaparat sa mergeti acolo!', 25, null, null);

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 8, 'dannyshere', '3r5t6y7u', 'utilizator', to_date('18-09-1999', 'dd-mm-yyyy'),7750);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Cireasa', 'Dan', 'dan_cireasa_65@yahoo.com', to_date('25-12-1967', 'dd-mm-yyyy'), 'M', '0779259651');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 98, SEQ_USER.CURRVAL, to_date('17-04-2019', 'dd-mm-yyyy'), '-Cine credeti ca este candidatul perfect pentru alegerile prezidentiale?');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 7, 'ioanber', 'truestortuio', 'admin_grup', to_date('15-03-2014', 'dd-mm-yyyy'), 10050);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Berescu', 'Ioan', 'ioanber@navrom.com', to_date('17-04-1993', 'dd-mm-yyyy'), 'M', '0732258306');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 214, SEQ_USER.CURRVAL, sysdate, 'Perusul meu este bolnav, i s-a uscat foarte tare ciocul. Aveti idee ce as putea face?');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, null,'cazyteo', '9340anf', 'utilizator',null, null, null);
INSERT INTO PROFIL VALUES(SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Cazamir', 'Teona', 'caza_teo@gmail.com', to_date('01-05-2003', 'dd-mm-yyyy'), 'F', '0721659400');
INSERT INTO POSTARE VALUES (SEQ_POST.NEXTVAL, 123, SEQ_USER.CURRVAL, sysdate, 'In urma unui studiu, s-a constatat ca o zi dureaza mai mult decât un an pe planeta Venus');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL,4, 'dascaluIonica76', 'raresana0306', 'utilizator', to_date('12-01-1995', 'dd-mm-yyyy'), 6032);
INSERT INTO PROFIL VALUES (SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Dascalu', 'Ionica', 'dascion@yahoo.com', to_date('05-03-1976', 'dd-mm-yyyy'), 'M', '0734805571');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL,1, 'liliMiuBuc', 'dr@gonbalk3j', 'admin_grup', to_date('20-02-1985', 'dd-mm-yyyy'),3500);
INSERT INTO PROFIL VALUES (SEQ_PROFILE.NEXTVAL,SEQ_USER.CURRVAL,  'Miu', 'Liliana', 'lilica_miu@gmail.com', to_date('14-04-1966', 'dd-mm-yyyy'), 'F', '0735206574');

INSERT INTO UTILIZATOR VALUES (SEQ_USER.NEXTVAL, 0, 'damiansuhov', 'skizoamabsaosoe', 'utilizator',to_date('30-04-2021', 'dd-mm-yyyy'), 4800);
INSERT INTO PROFIL VALUES (SEQ_PROFILE.NEXTVAL, SEQ_USER.CURRVAL,  'Suhov', 'Damian', 'dam.suh@s.unibuc.ro', to_date('01-06-2001', 'dd-mm-yyyy'), 'M', '0785203571');

INSERT INTO POSTARE VALUES(360, 23, 102, to_date('13-09-2020', 'dd-mm-yyyy'), '-De ce a trecut varza strada? -Ca era verde!');
INSERT INTO POSTARE VALUES(365, 23, 105, to_date('01-06-2019', 'dd-mm-yyyy'), '-De ce are rinocerul corn? -Fiindca nu a gasit paine!');
INSERT INTO POSTARE VALUES(370, 34, 109, to_date('15-10-2018', 'dd-mm-yyyy'), 'Simona Halep este o jucatoare de tenis din Romania care a atins prima pozitie în clasamentul mondial WTA, în doua rânduri, între 2017 si 2019.');
INSERT INTO POSTARE VALUES(375, 23, 113, sysdate, '-Cum obtii lumina cu ajutorul apei? -Speli geamurile!');
INSERT INTO POSTARE VALUES(380, 34, 107, sysdate, 'Nicolae Stanciu a fost titular în partida pe care Slavia Praga a castigat-o in fata celor de la Sigma Olomuc, scor 1-0.');

--COMENTARIU
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


--APRECIERE
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


--DISTRIBUIRE
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

--FRIEND_REQUEST
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

--SCRIE
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
INSERT INTO SCRIE VALUES(115, 8, 30);

--acestea au fost adaugate mai tarziu, pentru exercitii
INSERT INTO UTILIZATOR VALUES(115, 3, 'moscuuteodoraa', 'imiplacesacant1234', 'admin_grup', sysdate, null);
INSERT INTO PROFIL VALUES(215, 115, 'Moscu', 'Teodora', 'moscuteo@gmail.com', to_date('13-09-2000', 'dd-mm-yyyy'), 'F', '0762118954');


--EX6.
--Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat care sa 
--utilizeze doua tipuri de colectie studiate. Apelati subprogramul.

--Pentru fiecare utilizator, afisati postarile acestora, precum si numarul de aprecieri, distribuiri
--si comentarii pentru fiecare postare. Rezolvati cerinta folosind o procedura stocata.
       
CREATE OR REPLACE PROCEDURE info_utilizator_postare AS 
    contor NUMBER;
    j NUMBER;
    nr_likes NUMBER;
    nr_shares NUMBER;
    nr_comms NUMBER;
    
    TYPE info_postare IS RECORD (
                                cod_post postare.id_postare%TYPE,
                                data postare.data_postare%TYPE,
                                continut postare.continut%TYPE,
                                cod_user postare.id_utilizator%TYPE
                                );
         
    TYPE indx_postari IS TABLE OF info_postare INDEX BY BINARY_INTEGER;
    t_post indx_postari;
    
    TYPE imbri_cod_user IS TABLE OF utilizator.id_utilizator%TYPE;
    t_utilizatori imbri_cod_user := imbri_cod_user();

    TYPE imbri_username_user IS TABLE OF utilizator.username%TYPE;
    t_username_user imbri_username_user := imbri_username_user();
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('--------Informatii despre utilizatori si postarile acestora--------');
    DBMS_OUTPUT.NEW_LINE();
    SELECT id_utilizator BULK COLLECT INTO t_utilizatori
    FROM utilizator
    ORDER BY id_utilizator;
    
    SELECT username BULK COLLECT INTO t_username_user
    FROM utilizator
    ORDER BY id_utilizator;
    
    j:=t_username_user.FIRST;
    FOR u in t_utilizatori.FIRST..t_utilizatori.LAST LOOP
    
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul ' || t_utilizatori(u) || '(si username-ul ' || t_username_user(j) || ') a facut urmatoarele postari:');
        DBMS_OUTPUT.NEW_LINE();
        SELECT id_postare, data_postare, continut, id_utilizator 
        BULK COLLECT INTO t_post
        FROM postare
        WHERE id_utilizator = t_utilizatori(u);
        
        IF t_post.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  ' || 'Nicio postare facuta de acest utilizator!');
            DBMS_OUTPUT.NEW_LINE;
        
        ELSE
            contor :=0;
            FOR k IN t_post.FIRST..t_post.LAST LOOP
                contor := contor+1;
                DBMS_OUTPUT.PUT(' ' ||contor||'. (in data de '||t_post(k).data||') ' || t_post(k).continut);
                
                SELECT COUNT(*)
                INTO nr_likes 
                FROM apreciere
                WHERE id_postare = t_post(k).cod_post;
                
                SELECT COUNT(*)
                INTO nr_shares 
                FROM distribuire
                WHERE id_postare = t_post(k).cod_post;
                
                SELECT COUNT(*)
                INTO nr_comms
                FROM comentariu
                WHERE id_postare = t_post(k).cod_post;
                
                DBMS_OUTPUT.NEW_LINE();
                DBMS_OUTPUT.PUT_LINE('    Aceasta postare a adunat ' 
                                     || nr_likes || ' aprecieri, ' 
                                     || nr_shares || ' distribuiri si ' 
                                     || nr_comms || ' comentarii.'); 
                DBMS_OUTPUT.NEW_LINE();
            END LOOP;
        END IF;
        j := j+1;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END info_utilizator_postare;
/
EXECUTE info_utilizator_postare;

--EX7. 
--Formulati în limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat care sa 
--utilizeze un tip de cursor studiat. Apelati subprogramul.

SELECT id_categorie, nume_categorie, count(id_postare) "NUMAR DE POSTARI AFERENTE"
FROM categorie JOIN postare USING (id_categorie)
GROUP BY id_categorie, nume_categorie
HAVING COUNT(id_postare) = (SELECT max(count(id_postare))
                            FROM postare
                            GROUP BY id_categorie);
                            
--Pentru fiecare categorie, sa se afiseze codul, numele categoriei si numarul de postari 
--aferente acesteia. Pentru categoriile/categoria cu numar maxim de postari, afisati un mesaj corespunzator! 

CREATE OR REPLACE PROCEDURE info_categorii AS v_count_postari NUMBER;
                                              v_max_count_postari NUMBER;
    TYPE t_detalii_categorie IS RECORD
    (
        id_categorie categorie.id_categorie%TYPE,
        nume_categorie categorie.nume_categorie%TYPE
    );
    detalii_categorie t_detalii_categorie;
    
    CURSOR c_max_count_postari IS 
    SELECT max(count(id_postare))
    FROM postare
    GROUP BY id_categorie;
    
    CURSOR c_categorie RETURN t_detalii_categorie IS
    SELECT id_categorie, nume_categorie
    FROM categorie;
    
    CURSOR c_count_postari IS
    SELECT COUNT(id_postare) 
    FROM postare
    WHERE id_categorie = detalii_categorie.id_categorie;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('------Informatii despre categorii------');
    DBMS_OUTPUT.NEW_LINE();
    OPEN c_max_count_postari;
        FETCH c_max_count_postari INTO v_max_count_postari;
    CLOSE c_max_count_postari;
    
    OPEN c_categorie;
    LOOP
        FETCH c_categorie INTO detalii_categorie;
        EXIT WHEN c_categorie%NOTFOUND;
        
        OPEN c_count_postari;
            FETCH c_count_postari INTO v_count_postari;
        CLOSE c_count_postari;
        
        DBMS_OUTPUT.PUT_LINE(' -Cod categorie: ' || detalii_categorie.id_categorie); 
        DBMS_OUTPUT.PUT_LINE('   Denumire categorie: ' || detalii_categorie.nume_categorie);
                             
        IF v_count_postari = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   Nicio postare apartinand aceastei categorii!');
        ELSIF v_count_postari = v_max_count_postari THEN
            DBMS_OUTPUT.PUT_LINE('   Numar de postari aferente categoriei: ' || v_count_postari);
            DBMS_OUTPUT.PUT_LINE('   Categorie cu numar maxim de postari!');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('   Numar de postari aferente categoriei: ' || v_count_postari);
        END IF;
    DBMS_OUTPUT.NEW_LINE();
    END LOOP;
    CLOSE c_categorie;
END info_categorii;
/
EXECUTE info_categorii;
/


--EX8.
--Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat de tip 
--functie care sa utilizeze intr-o singura comanda SQL 3 dintre tabelele definite. Tratati toate exceptiile 
--care pot aparea. Apelati subprogramul astfel încât sa evidentiati toate cazurile tratate.

--Definiti un subprogram stocat de tip functie care sa returneze numarul de grupuri create intr-o anumita perioada 
--de timp de un administrator al carui job este dat. Atunci cand apelati functia, specificati daca administratorul
--este femeie sau barbat!

CREATE OR REPLACE FUNCTION grupuri_create_admin
    (v_job loc_munca.nume_job%TYPE, v_data_initiala DATE, v_data_finala DATE, v_sex profil.sex%TYPE)
RETURN NUMBER IS
    v_id_job loc_munca.id_job%TYPE;
    v_count NUMBER;
    zero_grupuri EXCEPTION;
BEGIN
    SELECT id_job INTO v_id_job 
    FROM loc_munca
    WHERE nume_job = v_job;
    
    --comanda sql care utilizeaza 4 tabele diferite
    SELECT COUNT(g.id_grup) INTO v_count
    FROM utilizator u 
            JOIN scrie s ON (u.id_utilizator = s.id_utilizator)
            JOIN grup g ON (g.id_grup =s.id_grup)
            JOIN profil p ON (u.id_utilizator = p.id_utilizator)
    WHERE u.id_job = v_id_job 
          AND g.data_creare >= v_data_initiala 
          AND g.data_creare <= v_data_finala 
          AND p.sex = v_sex;
    
    IF v_count = 0 THEN
        RAISE zero_grupuri;
    END IF;
    
    RETURN v_count;

EXCEPTION
    WHEN zero_grupuri THEN 
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun grup care sa respecte conditiile date!');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista niciun job cu numele dat!');
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END grupuri_create_admin;
/

--apel corect
BEGIN                   
    DBMS_OUTPUT.PUT_LINE('Numar de grupuri create de un web designer barbat din 01-10-2016 pana in 10-04-2018: ' 
                        || grupuri_create_admin('web designer', TO_DATE('01-oct-2016', 'dd-mon-yyyy'), 
                                                                TO_DATE('10-apr-2018', 'dd-mon-yyyy'), 'M'));
END;
/

--apel pentru care avem exceptie, deoarece job-ul 'avocat' nu exista in baza de date.
--in baza de date avem 'avocat_stagiar' si 'avocat_profesionist'
BEGIN                   
    DBMS_OUTPUT.PUT_LINE('Numar de grupuri create de un avocat barbat din 01-10-2016 pana in 10-04-2018: ' 
                        || grupuri_create_admin('avocat', TO_DATE('01-oct-2016', 'dd-mon-yyyy'), 
                                                                TO_DATE('10-apr-2018', 'dd-mon-yyyy'), 'M'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/

--apel pentru care se declanseaza exceptia definita de mine si se intra pe cazul de others, deoarece
--nu se va returna nicio valoare
BEGIN                   
    DBMS_OUTPUT.PUT_LINE('Numar de grupuri create de un doctor femeie din 01-10-2016 pana in 10-04-2018: ' 
                        || grupuri_create_admin('doctor', TO_DATE('01-oct-2016', 'dd-mon-yyyy'), 
                                                                TO_DATE('10-apr-2018', 'dd-mon-yyyy'), 'F'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/

--EX9.
--Formulati in limbaj natural o problema pe care sa o rezolvati folosind un subprogram stocat de tip 
--procedura care sa utilizeze intr-o singura comanda SQL 5 dintre tabelele definite. Tratati toate 
--exceptiile care pot aparea, incluzand exceptiile NO_DATA_FOUND si TOO_MANY_ROWS. Apelati 
--subprogramul astfel incat sa evidentiati toate cazurile tratate.

--Definiti un subprogram stocat de tip procedura care sa afiseze codul, luna in care a fost postata, categoria 
--de care apartine si continutul pentru postarea/postarile publicata/publicate de utilizatorii cu job-ul dat. 
--Afisati, de asemenea, unsername-ul si numele acestora. 

CREATE OR REPLACE PROCEDURE informatii_postari (v_nume_job loc_munca.nume_job%TYPE)
IS
    nicio_postare EXCEPTION;
    TYPE imbri_nume_job IS TABLE OF loc_munca.nume_job%TYPE;
    t_nume_job imbri_nume_job := imbri_nume_job();
    ok INTEGER;
    TYPE t_detalii_postare IS RECORD (
                                      v_cod postare.id_postare%TYPE,
                                      v_luna VARCHAR2(8),
                                      v_categorie categorie.nume_categorie%TYPE,
                                      v_continut postare.continut%TYPE,
                                      v_username utilizator.username%TYPE,
                                      v_nume profil.nume%TYPE,
                                      v_prenume profil.prenume%TYPE
                                      );
    TYPE lista IS TABLE OF  t_detalii_postare;
    l lista;
BEGIN 
    ok:=0;
    SELECT nume_job BULK COLLECT INTO t_nume_job
    FROM loc_munca
    ORDER BY nume_job;
    
    FOR job in t_nume_job.FIRST .. t_nume_job.LAST LOOP
        IF t_nume_job(job) LIKE v_nume_job ||'%' THEN
            ok :=ok + 1;
        END IF;
    END LOOP;
    
    IF ok = 0 THEN
        RAISE NO_DATA_FOUND;
    ELSIF ok > 1 THEN
        RAISE TOO_MANY_ROWS;
    ELSE 
        DBMS_OUTPUT.PUT_LINE('Istoric postari pentru utilizatorii cu jobul de: ' || v_nume_job);
        DBMS_OUTPUT.NEW_LINE();
    
    SELECT id_postare, 
           to_char(data_postare, 'MONTH'), 
           nume_categorie, 
           continut, 
           username, 
           prf.nume,
           prf.prenume
    BULK COLLECT INTO l
    --folosesc intr-o comanda sql tabelele postare, categorie, profil, utilizator, loc_munca
    FROM postare p, categorie c, profil prf, utilizator u  
    WHERE (p.id_categorie = c.id_categorie)AND 
          (p.id_utilizator = u.id_utilizator)AND
          (prf.id_utilizator = u.id_utilizator)AND 
          (u.id_utilizator in (SELECT id_utilizator 
                               FROM utilizator
                               WHERE id_job = (SELECT id_job
                                               FROM loc_munca
                                               WHERE lower(nume_job) LIKE v_nume_job || '%')));
    IF l.count=0 THEN 
        RAISE nicio_postare;
    ELSE
        FOR j in 1..l.count LOOP
            DBMS_OUTPUT.PUT_LINE('Utilizatorul ' || l(j).v_nume || ' ' || l(j).v_prenume || ' cu username-ul ' || l(j).v_username);
            DBMS_OUTPUT.PUT_LINE('   Cod postare: ' || l(j).v_cod);
            DBMS_OUTPUT.PUT_LINE('   Luna in care a fost facuta: ' || l(j).v_luna);
            DBMS_OUTPUT.PUT_LINE('   Categoria din care apartine: ' || l(j).v_categorie);
            DBMS_OUTPUT.PUT_LINE('   Continut: ' || l(j).v_continut);
            DBMS_OUTPUT.NEW_LINE();
        END LOOP;
    END IF;  
    END IF;
    DBMS_OUTPUT.NEW_LINE();
EXCEPTION
    WHEN NICIO_POSTARE THEN
        DBMS_OUTPUT.PUT_LINE('Nu s-a gasit nicio postare pentru acest job!');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista job-ul in baza de date!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Prea multe job-uri cu string-ul dat in nume!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'alta eroare');
END informatii_postari;
/

--apel pentru care se declanseaza exceptia TOO_MANY_ROWS, deoarece in baza de date avem atat
--locul de munca avocat_stagiar, cat si locul de munca avocat_profesionist
BEGIN
    informatii_postari('avocat');
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/

EXECUTE informatii_postari('psiholog');   --se afiseaza postarile corespunzatoare
/
BEGIN
    informatii_postari('job'); --se intra pe exceptia de no_data_found, deoarece nu exista aceasta
                               --denumire de job in baza de date
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;

EXECUTE informatii_postari('profesor'); --se intra pe exceptia definita de mine si se afiseaza mesajul corespunzator ei
                                        --deoarece nu exista nicio postare facuta de un profesor
                                        
--EX10.
--Definiti un trigger de tip LMD la nivel de comanda. Declansati trigger-ul.

--In fiecare luna, in ziua de 15(fie ea lucratoare sau nu), se fac verificari in baza de date pentru a se 
--asigura actualitatea categoriilor existente. Acest lucru dureaza o singura ora si se desfasoara intre 
--orele 09:00 si 10:00 dimineata. Creati un trigger LMD, care sa nu permita executarea niciunei comenzi 
--(inserare, stergere sau modificare) asupra tabelei de categorii in data de 15, in intervalul orar specificat.

CREATE OR REPLACE TRIGGER verificare_categorie
    BEFORE INSERT OR DELETE OR UPDATE ON categorie
BEGIN
    IF
        to_char(sysdate, 'dd/mm') = '15/01' OR
        to_char(sysdate, 'dd/mm') = '15/02' OR
        to_char(sysdate, 'dd/mm') = '15/03' OR
        to_char(sysdate, 'dd/mm') = '15/04' OR
        to_char(sysdate, 'dd/mm') = '15/05' OR
        to_char(sysdate, 'dd/mm') = '15/06' OR
        to_char(sysdate, 'dd/mm') = '15/07' OR
        to_char(sysdate, 'dd/mm') = '15/08' OR
        to_char(sysdate, 'dd/mm') = '15/09' OR
        to_char(sysdate, 'dd/mm') = '15/10' OR
        to_char(sysdate, 'dd/mm') = '15/11' OR
        to_char(sysdate, 'dd/mm') = '15/12'
        AND (to_char(sysdate, 'hh24') BETWEEN 9 AND 10)
        THEN
            IF INSERTING THEN 
                RAISE_APPLICATION_ERROR(-20010, 'Se fac verificari asupra categoriilor de postari! Inserati date in tabel dupa ora 10:00');
            ELSIF DELETING THEN
                RAISE_APPLICATION_ERROR(-20011, 'Se fac verificari asupra categoriilor de postari! Stergeti date din tabel dupa ora 10:00');
            ELSE
                RAISE_APPLICATION_ERROR(-20012, 'Se fac verificari asupra categoriilor de postari! Actualizati datele din tabel dupa ora 10:00');
            END IF;
        END IF;
END;

INSERT INTO CATEGORIE VALUES(88, 'ECONOMIE');

DELETE FROM CATEGORIE
WHERE id_categorie = 88;

UPDATE CATEGORIE 
SET ID_CATEGORIE = 89
WHERE ID_CATEGORIE = 88;

--EX11. Definiti un trigger de tip LMD la nivel de linie. Declansati trigger-ul.

--Definiti un trigger la nivel de linie care blocheaza permisiunea utilizatorului de a modifica data unui anunt
--odata ce acesta a fost scris. 

--primul trigger pe care l-am facut
CREATE OR REPLACE TRIGGER try1
BEFORE UPDATE OF data_anunt ON ANUNT 
    FOR EACH ROW 
    WHEN (NEW.data_anunt != OLD.data_anunt)
BEGIN
    RAISE_APPLICATION_ERROR(-20004,'Anuntul a fost deja postat! Nu ii puteti schimba data!');
END;
/
UPDATE ANUNT
SET data_anunt = '10-DEC-21'
WHERE id_anunt = 1;

--am mai facut un trigger pe tabela MUTATING pentru ca primul era prea simplu, dar l-am lasat si
--pe primul fiindca are sens sa nu pot modifica data unui anunt odata ce a fost postat

--Definiti un trigger care sa nu permita ca un utilizator sa posteze mai mult de 2 postari.

CREATE OR REPLACE TRIGGER check_max_postari
BEFORE INSERT OR UPDATE OF id_utilizator ON postare
FOR EACH ROW
DECLARE 
    nr_postari NUMBER(1);
BEGIN
    SELECT count(*) INTO nr_postari
    FROM postare
    WHERE id_utilizator = :NEW.id_utilizator;
    
    IF nr_postari = 2 THEN 
        RAISE_APPLICATION_ERROR(-20000, 'Utilizatorul a postat deja numarul maxim de postari!');
    END IF;
END;

--utilizatorul are deja numarul maxim de postari, se declanseaza triggerul
INSERT INTO postare VALUES(380, 23, 109, sysdate, 'Ce e rosu si nu e bun pentru dinti? Caramida!');

--functioneaza, deoarece utilizatorul cu id-ul 101 are doar o postare
INSERT INTO postare VALUES(SEQ_POST.NEXTVAL, 23, 101, sysdate, 'Ce e rosu si nu e bun pentru dinti? Caramida!');
rollback;

--comenzi ce genereaza eroare mutating
INSERT INTO postare
SELECT SEQ_POST.NEXTVAL, 23, 109, sysdate, 'Ce e rosu si nu e bun pentru dinti? Caramida!'
FROM DUAL;

--solutie pentru rezolvarea erorii de tabel mutating

CREATE OR REPLACE PACKAGE pachet_check_max_postari
AS
    TYPE tip_rec IS RECORD
    (cod postare.id_utilizator%TYPE,
     nr_postari NUMBER(1));
    
    TYPE tip_ind IS TABLE OF tip_rec INDEX BY PLS_INTEGER;
    t tip_ind;
    contor NUMBER(2) :=0;
END;
/
CREATE OR REPLACE TRIGGER check_max_postari_t_comanda
    BEFORE INSERT OR UPDATE OF id_utilizator ON postare
BEGIN

    pachet_check_max_postari.contor := 0;
    
    SELECT id_utilizator, count(*) BULK COLLECT INTO pachet_check_max_postari.t
    FROM  postare
    GROUP BY id_utilizator;
END;
/
CREATE OR REPLACE TRIGGER check_max_postari_t_linie
    BEFORE INSERT OR UPDATE OF id_utilizator ON POSTARE
    FOR EACH ROW
BEGIN
    FOR i in 1..pachet_check_max_postari.t.LAST LOOP
        IF pachet_check_max_postari.t(i).cod = :NEW.id_utilizator
            AND pachet_check_max_postari.t(i).nr_postari + pachet_check_max_postari.contor = 2 
        THEN
            RAISE_APPLICATION_ERROR(-20000, 'Utilizatorul ' || :NEW.id_utilizator || ' depaseste numarul maxim de postari!');
        END IF;
    END LOOP;
    pachet_check_max_postari.contor := pachet_check_max_postari.contor + 1;
END;
/

--comenzi ce generau eroare mutating inainte, acum declanseaza triggerul
INSERT INTO postare
SELECT SEQ_POST.NEXTVAL, 23, 109, sysdate, 'Ce e rosu si nu e bun pentru dinti? Caramida!'
FROM DUAL;

--EX12.
--Definiti un trigger de tip LDD. Declansati trigger-ul.

--Definiti un trigger care sa salveze informatii despre eventuale modificari asupra bazei de date.
--De asemenea, blocati adaugarea/modificarea/stergerea tabelelor in afara programului de lucru(adica 
--in zilele de sambata si duminica si in timpul saptamanii in afara orelor 8:00 - 16:00). 
--Tineti cont de faptul ca in data de 15 a fiecarei luni, baza de date este in mentenanta. (vezi ex.10)

CREATE TABLE informatii_baza_date 
    (nume_baza_date VARCHAR2(50),
     utilizator_activ VARCHAR2(50),
     obiect VARCHAR2(50),
     comanda VARCHAR2(50),
     data DATE
     );

CREATE OR REPLACE TRIGGER verifica_modificari
    AFTER CREATE OR DROP OR ALTER ON schema
BEGIN
    IF to_char(sysdate, 'day') = 'saturday' OR
       to_char(sysdate, 'day') = 'sunday' THEN  
       
       RAISE_APPLICATION_ERROR(-20000, 'In weekend nu se lucreaza!');
    
    ELSIF to_char(sysdate, 'hh24') NOT BETWEEN 8 AND 16 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Nu sunteti in perioada orelor lucratoare!');
    END IF;
    
    IF
        to_char(sysdate, 'dd/mm') = '15/01' OR
        to_char(sysdate, 'dd/mm') = '15/02' OR
        to_char(sysdate, 'dd/mm') = '15/03' OR
        to_char(sysdate, 'dd/mm') = '15/04' OR
        to_char(sysdate, 'dd/mm') = '15/05' OR
        to_char(sysdate, 'dd/mm') = '15/06' OR
        to_char(sysdate, 'dd/mm') = '15/07' OR
        to_char(sysdate, 'dd/mm') = '15/08' OR
        to_char(sysdate, 'dd/mm') = '15/09' OR
        to_char(sysdate, 'dd/mm') = '15/10' OR
        to_char(sysdate, 'dd/mm') = '15/11' OR
        to_char(sysdate, 'dd/mm') = '15/12'
    THEN
        RAISE_APPLICATION_ERROR(-20002, 'Baza de date este in mentenanta!');
    END IF;
    
    INSERT INTO informatii_baza_date VALUES(sys.database_name, sys.login_user, sys.dictionary_obj_name, sys.sysevent, sysdate);
END;
/
create table testeaza2(cod varchar2(10));
drop table testeaza2;

create table testeaza_mentenanta(cod varchar2(15));

create table testeaza_ore_lucru(cod varchar2(20));

select * from informatii_baza_date;

--------------------------------------------CERINTE DE COMPLEXITATE MAI MARE----------------------------------------

--EX13. Definiti un pachet care sa contina toate obiectele definite în cadrul proiectului.

CREATE OR REPLACE PACKAGE proiect_raluca AS
    PROCEDURE info_utilizator_postare;  --ex6
    PROCEDURE info_categorii; --ex7
    FUNCTION grupuri_create_admin (v_job loc_munca.nume_job%TYPE, v_data_initiala DATE,
                                   v_data_finala DATE, v_sex profil.sex%TYPE) RETURN NUMBER; --ex8
    PROCEDURE informatii_postari (v_nume_job loc_munca.nume_job%TYPE); --ex9

END proiect_raluca;
/
CREATE OR REPLACE PACKAGE BODY proiect_raluca AS
    --ex6
    PROCEDURE info_utilizator_postare AS 
    contor NUMBER;
    j NUMBER;
    nr_likes NUMBER;
    nr_shares NUMBER;
    nr_comms NUMBER;
    
    TYPE info_postare IS RECORD (
                                cod_post postare.id_postare%TYPE,
                                data postare.data_postare%TYPE,
                                continut postare.continut%TYPE,
                                cod_user postare.id_utilizator%TYPE
                                );
         
    TYPE indx_postari IS TABLE OF info_postare INDEX BY BINARY_INTEGER;
    t_post indx_postari;
    
    TYPE imbri_cod_user IS TABLE OF utilizator.id_utilizator%TYPE;
    t_utilizatori imbri_cod_user := imbri_cod_user();

    TYPE imbri_username_user IS TABLE OF utilizator.username%TYPE;
    t_username_user imbri_username_user := imbri_username_user();
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('--------Informatii despre utilizatori si postarile acestora--------');
    DBMS_OUTPUT.NEW_LINE();
    SELECT id_utilizator BULK COLLECT INTO t_utilizatori
    FROM utilizator
    ORDER BY id_utilizator;
    
    SELECT username BULK COLLECT INTO t_username_user
    FROM utilizator
    ORDER BY id_utilizator;
    
    j:=t_username_user.FIRST;
    FOR u in t_utilizatori.FIRST..t_utilizatori.LAST LOOP
    
        DBMS_OUTPUT.PUT_LINE('Utilizatorul cu id-ul ' || t_utilizatori(u) || '(si username-ul ' || t_username_user(j) || ') a facut urmatoarele postari:');
        DBMS_OUTPUT.NEW_LINE();
        SELECT id_postare, data_postare, continut, id_utilizator 
        BULK COLLECT INTO t_post
        FROM postare
        WHERE id_utilizator = t_utilizatori(u);
        
        IF t_post.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE('  ' || 'Nicio postare facuta de acest utilizator!');
            DBMS_OUTPUT.NEW_LINE;
        
        ELSE
            contor :=0;
            FOR k IN t_post.FIRST..t_post.LAST LOOP
                contor := contor+1;
                DBMS_OUTPUT.PUT(' ' ||contor||'. (in data de '||t_post(k).data||') ' || t_post(k).continut);
                
                SELECT COUNT(*)
                INTO nr_likes 
                FROM apreciere
                WHERE id_postare = t_post(k).cod_post;
                
                SELECT COUNT(*)
                INTO nr_shares 
                FROM distribuire
                WHERE id_postare = t_post(k).cod_post;
                
                SELECT COUNT(*)
                INTO nr_comms
                FROM comentariu
                WHERE id_postare = t_post(k).cod_post;
                DBMS_OUTPUT.NEW_LINE();
                DBMS_OUTPUT.PUT_LINE('    Aceasta postare a adunat ' 
                                     || nr_likes || ' aprecieri, ' 
                                     || nr_shares || ' distribuiri si ' 
                                     || nr_comms || ' comentarii.'); 
                DBMS_OUTPUT.NEW_LINE();
            END LOOP;
        END IF;
        j := j+1;
        DBMS_OUTPUT.NEW_LINE();
    END LOOP;
END info_utilizator_postare;

--ex7
    PROCEDURE info_categorii AS v_count_postari NUMBER;
                                              v_max_count_postari NUMBER;
    TYPE t_detalii_categorie IS RECORD
    (
        id_categorie categorie.id_categorie%TYPE,
        nume_categorie categorie.nume_categorie%TYPE
    );
    detalii_categorie t_detalii_categorie;
    
    CURSOR c_max_count_postari IS 
    SELECT max(count(id_postare))
    FROM postare
    GROUP BY id_categorie;
    
    CURSOR c_categorie RETURN t_detalii_categorie IS
    SELECT id_categorie, nume_categorie
    FROM categorie;
    
    CURSOR c_count_postari IS
    SELECT COUNT(id_postare) 
    FROM postare
    WHERE id_categorie = detalii_categorie.id_categorie;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('------Informatii despre categorii------');
    DBMS_OUTPUT.NEW_LINE();
    OPEN c_max_count_postari;
        FETCH c_max_count_postari INTO v_max_count_postari;
    CLOSE c_max_count_postari;
    
    OPEN c_categorie;
    LOOP
        FETCH c_categorie INTO detalii_categorie;
        EXIT WHEN c_categorie%NOTFOUND;
        
        OPEN c_count_postari;
            FETCH c_count_postari INTO v_count_postari;
        CLOSE c_count_postari;
        
        DBMS_OUTPUT.PUT_LINE(' -Cod categorie: ' || detalii_categorie.id_categorie); 
        DBMS_OUTPUT.PUT_LINE('   Denumire categorie: ' || detalii_categorie.nume_categorie);
                             
        IF v_count_postari = 0 THEN
            DBMS_OUTPUT.PUT_LINE('   Nicio postare apartinand aceastei categorii!');
        ELSIF v_count_postari = v_max_count_postari THEN
            DBMS_OUTPUT.PUT_LINE('   Numar de postari aferente categoriei: ' || v_count_postari);
            DBMS_OUTPUT.PUT_LINE('   Categorie cu numar maxim de postari!');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('   Numar de postari aferente categoriei: ' || v_count_postari);
        END IF;
    DBMS_OUTPUT.NEW_LINE();
    END LOOP;
    CLOSE c_categorie;
END info_categorii;

--ex8
FUNCTION grupuri_create_admin
    (v_job loc_munca.nume_job%TYPE, v_data_initiala DATE, v_data_finala DATE, v_sex profil.sex%TYPE)
RETURN NUMBER IS
    v_id_job loc_munca.id_job%TYPE;
    v_count NUMBER;
    zero_grupuri EXCEPTION;
BEGIN
    SELECT id_job INTO v_id_job 
    FROM loc_munca
    WHERE nume_job = v_job;
    
    --comanda sql care utilizeaza tabelele utilizator, scrie, grup, profil
    SELECT COUNT(g.id_grup) INTO v_count
    FROM utilizator u 
            JOIN scrie s ON (u.id_utilizator = s.id_utilizator)
            JOIN grup g ON (g.id_grup =s.id_grup)
            JOIN profil p ON (u.id_utilizator = p.id_utilizator)
    WHERE u.id_job = v_id_job 
          AND g.data_creare >= v_data_initiala 
          AND g.data_creare <= v_data_finala 
          AND p.sex = v_sex;
    
    IF v_count = 0 THEN
        RAISE zero_grupuri;
    END IF;
    
    RETURN v_count;

EXCEPTION
    WHEN ZERO_GRUPURI THEN 
        DBMS_OUTPUT.PUT_LINE('Nu exista niciun grup care sa respecte conditiile date!');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista niciun job cu numele dat!');
     WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END grupuri_create_admin;

--ex9
PROCEDURE informatii_postari (v_nume_job loc_munca.nume_job%TYPE)
IS
    nicio_postare EXCEPTION;
    TYPE imbri_nume_job IS TABLE OF loc_munca.nume_job%TYPE;
    t_nume_job imbri_nume_job := imbri_nume_job();
    ok INTEGER;
    TYPE t_detalii_postare IS RECORD (
                                      v_cod postare.id_postare%TYPE,
                                      v_luna VARCHAR2(8),
                                      v_categorie categorie.nume_categorie%TYPE,
                                      v_continut postare.continut%TYPE,
                                      v_username utilizator.username%TYPE,
                                      v_nume profil.nume%TYPE,
                                      v_prenume profil.prenume%TYPE
                                      );
    TYPE lista IS TABLE OF  t_detalii_postare;
    l lista;
BEGIN 
    ok:=0;
    SELECT nume_job BULK COLLECT INTO t_nume_job
    FROM loc_munca
    ORDER BY nume_job;
    
    FOR job in t_nume_job.FIRST .. t_nume_job.LAST LOOP
        IF t_nume_job(job) LIKE v_nume_job ||'%' THEN
            ok :=ok + 1;
        END IF;
    END LOOP;
    
    IF ok = 0 THEN
        RAISE NO_DATA_FOUND;
    ELSIF ok > 1 THEN
        RAISE TOO_MANY_ROWS;
    ELSE 
    DBMS_OUTPUT.PUT_LINE('Istoric postari pentru utilizatorii cu jobul de: ' || v_nume_job);
    DBMS_OUTPUT.NEW_LINE();
    
    SELECT id_postare, 
           to_char(data_postare, 'MONTH'), 
           nume_categorie, 
           continut, 
           username, 
           prf.nume,
           prf.prenume
    BULK COLLECT INTO l
    --folosirea intr-o comanda sql a 5 tabele(postare, categorie, profil, utilizator, loc_munca)
    FROM postare p, categorie c, profil prf, utilizator u
    WHERE (p.id_categorie = c.id_categorie)AND 
          (p.id_utilizator = u.id_utilizator)AND
          (prf.id_utilizator = u.id_utilizator)AND 
          (u.id_utilizator in (SELECT id_utilizator 
                               FROM utilizator
                               WHERE id_job = (SELECT id_job
                                               FROM loc_munca
                                               WHERE lower(nume_job) LIKE v_nume_job || '%')));
    IF l.count=0 THEN 
        RAISE nicio_postare;
    ELSE
        FOR j in 1..l.count LOOP
            DBMS_OUTPUT.PUT_LINE('Utilizatorul ' || l(j).v_nume || ' ' || l(j).v_prenume || ' cu username-ul ' || l(j).v_username);
            DBMS_OUTPUT.PUT_LINE('   Cod postare: ' || l(j).v_cod);
            DBMS_OUTPUT.PUT_LINE('   Luna in care a fost facuta: ' || l(j).v_luna);
            DBMS_OUTPUT.PUT_LINE('   Categoria din care apartine: ' || l(j).v_categorie);
            DBMS_OUTPUT.PUT_LINE('   Continut: ' || l(j).v_continut);
            DBMS_OUTPUT.NEW_LINE();
        END LOOP;
    END IF;  
    END IF;
    DBMS_OUTPUT.NEW_LINE();
EXCEPTION
    WHEN NICIO_POSTARE THEN
        DBMS_OUTPUT.PUT_LINE('Nu s-a gasit nicio postare pentru acest job!');
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20000, 'Nu exista job-ul in baza de date!');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Prea multe job-uri cu string-ul dat in nume!');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'alta eroare');
END informatii_postari;

END proiect_raluca;
/

--test ex 6
execute proiect_raluca.info_utilizator_postare();

--test ex 7
execute proiect_raluca.info_categorii();

--test ex 8
--apel corect
BEGIN                   
    DBMS_OUTPUT.PUT_LINE('Numar de grupuri create de un web designer barbat din 01-10-2016 pana in 10-04-2018: ' 
                        || proiect_raluca.grupuri_create_admin('web designer', TO_DATE('01-oct-2016', 'dd-mon-yyyy'), 
                                                                TO_DATE('10-apr-2018', 'dd-mon-yyyy'), 'M'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/

--apel pentru care avem exceptie de NO_DATA_FOUND
BEGIN                   
    DBMS_OUTPUT.PUT_LINE('Numar de grupuri create de un avocat barbat din 01-10-2016 pana in 10-04-2018: ' 
                        || proiect_raluca.grupuri_create_admin('avocat', TO_DATE('01-oct-2016', 'dd-mon-yyyy'), 
                                                                TO_DATE('10-apr-2018', 'dd-mon-yyyy'), 'M'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/

--apel pentru care se declanseaza exceptia definita de mine si se intra pe cazul de others, deoarece
--nu se va returna nicio valoare
BEGIN                   
    DBMS_OUTPUT.PUT_LINE('Numar de grupuri create de un doctor de sex femnin din 01-10-2016 pana in 10-04-2018: ' 
                        || proiect_raluca.grupuri_create_admin('doctor', TO_DATE('01-oct-2016', 'dd-mon-yyyy'), 
                                                                TO_DATE('10-apr-2018', 'dd-mon-yyyy'), 'F'));
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/

--test ex9
--apel pentru care se declanseaza exceptia TOO_MANY_ROWS, deoarece in baza de date avem atat
--locul de munca avocat_stagiar, cat si locul de munca avocat_profesionist
BEGIN
    proiect_raluca.informatii_postari('avocat');
EXCEPTION 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;
/

EXECUTE proiect_raluca.informatii_postari('psiholog');   --se afiseaza postarile corespunzatoare

BEGIN
    proiect_raluca.informatii_postari('job'); --se intra pe exceptia de no_data_found, deoarece nu exista aceasta
                               --denumire de job in baza de date
EXCEPTION
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Eroare cu codul '||SQLCODE|| ' si mesajul ' || SQLERRM);
END;

EXECUTE proiect_raluca.informatii_postari('profesor'); --se intra pe exceptia definita de mine si se afiseaza mesajul corespunzator ei
                                        --deoarece nu exista nicio postare facuta de un profesor
                                        
                                   
--EX14.Definiti un pachet care sa includa tipuri de date complexe si obiecte necesare unui flux de actiuni 
--integrate, specifice bazei de date definite (minim 2 tipuri de date, minim 2 func?ii, minim 2 proceduri).

--O data pe an, managerul aplicatiei de socializare face un bilant in urma caruia recompenseaza
--cativa dintre utilizatorii cei mai activ printr-un giveaway a carui suma este variabila
--in functie de numarul de reactii si de postari ale fiecarui utilizator. 
--Suma totala se calculeaza astfel: - pentru fiecare postare facuta - 50 lei
--                                  - pentru fiecare postare din categoria DIVERTISMENT, 
--                                  utilizatorii primesc bonus 20 lei 
--                                  - fiecare comentariu, distribuire, apreciere primesc cate 5 lei
--Sa se afiseze cat ar oferi managerul fiecaruia. Giveaway ul se va face online, nu in baza de date.

--select prin care aflu cate postari face fiecare utilizator
SELECT id_utilizator, COUNT(id_postare)
FROM postare JOIN utilizator USING(id_utilizator)
GROUP BY id_utilizator;


--select prin care aflu utilizatorii care au scris postari din categoria DIVERTISMENT
SELECT p.id_utilizator
FROM utilizator u join postare p on u.id_utilizator = p.id_utilizator 
                              join categorie c on p.id_categorie = c.id_categorie
WHERE upper(nume_categorie) = 'DIVERTISMENT'
GROUP BY p.id_utilizator;

CREATE OR REPLACE PACKAGE pachet_raluca_2
AS
    TYPE t_utilizator IS RECORD(id_utilizator utilizator.id_utilizator%TYPE,
                                username utilizator.username%TYPE,
                                nume_utilizator profil.nume%TYPE,
                                prenume_utilizator profil.prenume%TYPE);
    CURSOR c_utilizator RETURN t_utilizator;
    FUNCTION bonus_divertisment (v_utilizator NUMBER) RETURN NUMBER;
    FUNCTION suma_per_utilizator (v_username utilizator.username%TYPE) RETURN NUMBER;
END pachet_raluca_2;
/
CREATE OR REPLACE PACKAGE BODY pachet_raluca_2
AS
    CURSOR c_utilizator RETURN t_utilizator 
    IS SELECT id_utilizator, username, nume, prenume
    FROM utilizator join profil using (id_utilizator);
    
    FUNCTION bonus_divertisment(v_utilizator NUMBER) RETURN NUMBER IS
        TYPE v_divertisment IS TABLE OF NUMBER;
        t v_divertisment;
        
        BEGIN
            SELECT p.id_utilizator BULK COLLECT INTO t
            FROM utilizator u join postare p on u.id_utilizator = p.id_utilizator 
                              join categorie c on p.id_categorie = c.id_categorie
            WHERE upper(nume_categorie) = 'DIVERTISMENT'
            GROUP BY p.id_utilizator;
            
            IF t.count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Niciun utilizator care sa fi postat ceva din categoria divertisment!');
                RETURN 0;
            END IF;
                
            FOR i in 1..t.count LOOP
                IF t(i) = v_utilizator THEN 
                    RETURN 1;
                END IF;
            END LOOP;
            RETURN 0;
        END;
        
        FUNCTION suma_per_utilizator (v_username utilizator.username%TYPE) RETURN NUMBER IS
        CURSOR c IS select id_utilizator, count(id_postare) nr
                    from postare join utilizator using(id_utilizator)
                    group by id_utilizator;
                    
        aux_id number;
        
        BEGIN
            SELECT id_utilizator INTO aux_id
            FROM utilizator WHERE username = v_username;
            
            FOR i in C LOOP 
                IF aux_id = i.id_utilizator THEN
                    RETURN i.nr * 50;
                END IF;
            END LOOP;
            RETURN 0;
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR (-20000, 'Nu exista acest username in baza de date!');
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR (-20002, 'Alta eroare!');
        END;
        
END PACHET_RALUCA_2;

BEGIN
    FOR i IN pachet_raluca_2.c_utilizator LOOP
        DBMS_OUTPUT.PUT_LINE('Utilizatorul ' || i.username || ' va primi suma de '
                            ||pachet_raluca_2.suma_per_utilizator(i.username) || ' lei '
                            ||' si pentru categoriile de divertisment ' || pachet_raluca_2.bonus_divertisment(i.id_utilizator) * 50);
    END LOOP;
END;

        
          