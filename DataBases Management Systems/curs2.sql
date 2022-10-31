--exemplul 1: 
DECLARE 
    x varchar2(50);
BEGIN
    x := 'Sandu Raluca-Ioana'; --variabila din blocul principal
    DECLARE
        y varchar2(30) := 'grupa'; --variabila din primul subbloc
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Tema realizata de '|| x);
        DBMS_OUTPUT.PUT_LINE(y || ' 242');
        x := 'SGBD';  --modific valoarea lui x
        y := 'anul 2'; --modific valoarea lui y
        DBMS_OUTPUT.PUT_LINE(x);  --afisez noua valoare a lui x
        DBMS_OUTPUT.PUT_LINE(y); --afisez noua valoarea a lui y
        DECLARE
            data_tema date default sysdate; --variabila din al doilea subbloc
        BEGIN 
            DBMS_OUTPUT.PUT_LINE('Data realizarii temei este ' || data_tema);
            x := 'Am rezolvat acest exercitiu'; --modific valoarea lui x
            y := 'semestrul 1';  --modific valoarea lui y
            data_tema := '18-oct-2021'; --modific valoarea lui data_tema
            DBMS_OUTPUT.PUT_LINE(x); --afisez noua valoare a lui x
            DBMS_OUTPUT.PUT_LINE(y); --afisez noua valoare a lui y
            DBMS_OUTPUT.PUT_LINE(data_tema); --afisez noua valoare a lui data_tema
            DECLARE 
                deadline date := '21-OCT-2021'; --variabila din al treilea subbloc
            BEGIN
                DBMS_OUTPUT.PUT_LINE('Deadline-ul temei este ' || deadline);
                x := 'Sisteme de Gestiune a Bazelor de Date'; --modific valoarea lui x
                y := 'Anul 2, Semestrul 1'; --modific valoarea lui y
                data_tema := '19-oct-2021'; --modific valoaea lui data_tema
                deadline := '22-oct-2021'; --modific valoarea lui deadline
                DBMS_OUTPUT.PUT_LINE(x); --afisez noua valoare a lui x
                DBMS_OUTPUT.PUT_LINE(y); --afisez noua valoare a lui y
                DBMS_OUTPUT.PUT_LINE(data_tema); --afisez noua valoare a lui data_tema
                DBMS_OUTPUT.PUT_LINE('Noul deadldine este ' || deadline); --afisez noua valoare a lui deadline
            END;
        END;
    END;
    DBMS_OUTPUT.PUT_LINE('Materia este ' || x);
--  DBMS_OUTPUT.PUT_LINE(y);
--  DBMS_OUTPUT.PUT_LINE(data_tema);
--  DBMS_OUTPUT.PUT_LINE(deadline);
END;

--Stim ca variabilele sunt vizibile in blocurile in care sunt declarate, precum
--si in toate subblocurile declarate in blocul respectiv. Daca o variabila
--nu este declarata local in bloc, atunci ea este cautata in sectiunea declarativa
--a blocurilor care includ blocul respectiv. In cazul nostru, eroare apare in 
--momentul in care decomentam oricare din liniile DBMS_OUTPUT.PUT_LINE(y); , 
--DBMS_OUTPUT.PUT_LINE(data_tema); si, respectiv, DBMS_OUTPUT.PUT_LINE(deadline);
--scrise la final, intrucat variabilele y, data_tema si deadline nu au fost 
--declarate in blocul principal, si din acest motiv compilatorul nu le poate
--vedea. Ele sunt declarate in interiorul subblocurilor. O alta eroare ar putea
--aparea atunci cand nu respectam constrangerile variabilelor. De exemplu, 
--daca x ar fi fost de forma varchar2(30), am fi primit o eroare atunci cand
--am fi incercat sa punem 'Sisteme de Gestiune a Bazelor de Date' in x, deoarece
--textul are mai multe caractere decat dimensiunea impusa initial. 


--exemplul 2:
DECLARE 
    nume_categ varchar2(30);
BEGIN
    nume_categ := 'thriller'; 
    DECLARE
        data_aparitie date := '24-sep-2021';
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Prima categorie: ' || nume_categ);
        DBMS_OUTPUT.PUT_LINE('Data aparitiei primului film: ' || data_aparitie);
        nume_categ := 'actiune';
        data_aparitie := '25-sep-2021';
        DBMS_OUTPUT.PUT_LINE('A doua categorie: ' || nume_categ);
        DBMS_OUTPUT.PUT_LINE('A doua data de aparitie: ' || data_aparitie);
        DECLARE
            nr_locuri number:= 300;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Numarul de locuri disponibile: ' || nr_locuri);
            nume_categ := 'drama';
            data_aparitie := '26-sep-2021';
            DBMS_OUTPUT.PUT_LINE('A treia categorie: ' || nume_categ);
            DBMS_OUTPUT.PUT_LINE('A treia data de aparitie: ' || data_aparitie);
        END;
        DBMS_OUTPUT.PUT_LINE('test: ' || nume_categ);
        DBMS_OUTPUT.PUT_LINE('test: ' || data_aparitie);
--      DBMS_OUTPUT.PUT_LINE('test: ' || nr_locuri);
    END;
--  DBMS_OUTPUT.PUT_LINE('test: ' || data_aparitie);
    DECLARE 
        nume_film varchar2(50) := 'The Guilty' ;
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Numele primului film: ' || nume_film);
        DBMS_OUTPUT.PUT_LINE('Numele categoriei: ' || nume_categ);
        nume_categ := 'dragoste';
        nume_film := 'The fault in our stars'; 
        DBMS_OUTPUT.PUT_LINE('Al doilea film: ' || nume_film);
        DBMS_OUTPUT.PUT_LINE('A patra categorie: ' || nume_categ);
        DECLARE
            pret_bilet number := 15;
        BEGIN
            DBMS_OUTPUT.PUT_LINE('Pretul primului film(in lei): ' || pret_bilet);
            pret_bilet := 30;
            DBMS_OUTPUT.PUT_LINE('Pretul pt al doilea film(lei): ' || pret_bilet);
        END; 
        DBMS_OUTPUT.PUT_LINE('test: ' || nume_categ);
        DBMS_OUTPUT.PUT_LINE('test: ' || nume_film);
--      DBMS_OUTPUT.PUT_LINE('test: ' || pret_bilet);
--      DBMS_OUTPUT.PUT_LINE('test: ' || data_aparitie);
    END;
    DBMS_OUTPUT.PUT_LINE('test: ' || nume_categ);
--  DBMS_OUTPUT.PUT_LINE('test: ' || nume_film);
END;

--La fel ca la exemplul precedent, erorile apar la liniile comentate. Atunci cand
--o variabila este declarata intr-un subbloc dintr-un alt subbloc, ea 
--devine inaccesibila in exterior. 