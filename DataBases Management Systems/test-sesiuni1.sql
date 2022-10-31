----sesiunea 2
SELECT * FROM member_rsa
WHERE member_id >=106 and member_id <=109 FOR UPDATE NOWAIT;

----sesiunea 2
SELECT * FROM member_rsa
WHERE member_id >=106 and member_id <=110 FOR UPDATE WAIT 10;

COMMIT;
--Ruland aceasta cerere in sesiunea 2, vom obtine o eroare conform careia timpul(timeout) a expirat. NOWAIT-ul din aceasta sesiune
--nu asteapta deblocarea liniilor din prima sesiune si de aceea intoarce o eroare (deoarece vrem sa afisam aceleasi informatii). 
--Practic, e ca si cum doi utilizatori ar vrea sa faca in acelasi timp acelasi lucru. 
--Daca primul utilizator vrea sa blocheze liniile pentru UPDATE, asteapta sa fie resursele accesibile.
--Acest lucru nu se intampla deoarece in sesiunea a doua am pus conditia de NOWAIT. Daca am da WAIT x secunde, 
--atunci el asteapta x secunde pentru a debloca resursele, insa daca nu au fost deblocate in cele x secunde, 
--atunci se va intoarce iarasi o eroare, conform careia timpul de asteptare a expirat,
--iar resursa inca este ocupata. Pentru a rezolva aceasta problema, trebuie sa dam un COMMIT in prima sesiune. Practic, asa 
--are loc deblocarea resurselor. 

--alta situatie
SELECT * FROM member_rsa
WHERE member_id >= 103 and member_id <= 110 FOR UPDATE SKIP LOCKED;

--Aceasta cerere va sari peste liniile blocate, afisand practic doar ce este neblocat, adica membrii cu id-urile 
--103,104,105,110.  Daca dam COMMIT in prima sesiune, adica deblocam liniile, se vor afisa toti membrii. 