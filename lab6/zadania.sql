-- użytkownik A: INF145407 Ryszard Poznański
-- użytkownik B: INF145256 Natalia Matykiewicz
-- użytkownik C: INF144566 Jan Sobański

--Zadanie 1
-- użytkownik A
select * from inf145256.pracownicy;
-- ORA-00942: tabela lub perspektywa nie istnieje

-- użytkownik B
SELECT * FROM INF145407.PRACOWNICY;
-- ORA-00942: tabela lub perspektywa nie istnieje

-- Zadanie 2
-- użytkownik B
GRANT SELECT ON PRACOWNICY
TO INF145407;

-- zadanie 3
-- użytkownik A
select * from inf145256.pracownicy;
-- uprawnienia działają

-- zadanie 4
-- użytkownik A
GRANT UPDATE(placa_pod, placa_dod) ON pracownicy TO inf145256;

--Zadanie 5
-- użytkownik B
UPDATE INF145407.PRACOWNICY SET placa_pod = placa_pod*2;
-- ORA-01031: niewystarczające uprawnienia
-- brak uprawnien do odczytu placa_pod

UPDATE INF145407.PRACOWNICY SET PLACA_POD = 2000 WHERE NAZWISKO='MORZY';
-- ORA-01031: niewystarczające uprawnienia
-- brak uprawnien do odczytu nazwiska

UPDATE INF145407.PRACOWNICY SET PLACA_DOD = 700;
-- 17 rows updated.

-- Zadanie 6 
-- użytkownik B
CREATE SYNONYM prac_145407 FOR INF145407.PRACOWNICY;

UPDATE PRAC_145407 SET PLACA_DOD = 800;

COMMIT;

-- Zadanie 7
-- użytkownik B
SELECT * FROM PRAC_145407;
-- ORA-01031: niewystarczające uprawnienia

-- Zadanie 8
-- użytkownik A
select owner, table_name, grantee, grantor, privilege
from user_tab_privs;
-- INF145256 PRACOWNICY INF145407 INF145256 SELECT

select table_name, grantee, grantor, privilege
from user_tab_privs_made;
-- INF145407 PUBLIC INF145407 INHERIT PRIVILEGES

select owner, table_name, grantor, privilege
from user_tab_privs_recd;
-- INF145256 PRACOWNICY INF145256 SELECT

select owner, table_name, column_name, grantee, grantor, privilege
from user_col_privs; 
-- INF145407 PRACOWNICY PLACA_DOD INF145256 INF145407 UPDATE
-- INF145407 PRACOWNICY PLACA_POD INF145256 INF145407 UPDATE

select table_name, column_name, grantee, grantor, privilege
from user_col_privs_made;
-- PRACOWNICY PLACA_DOD INF145256 INF145407 UPDATE
-- PRACOWNICY PLACA_POD INF145256 INF145407 UPDATE

select owner, table_name, column_name, grantor, privilege
from user_col_privs_recd;
-- No items to display

-- użytkownik B
select owner, table_name, grantee, grantor, privilege
from user_tab_privs;
-- grantee INF145407 privilege SELECT table_name PRACOWNICY

select table_name, grantee, grantor, privilege
from user_tab_privs_made; 
-- grantee INF145407 privilege SELECT table_name PRACOWNICY

select owner, table_name, grantor, privilege
from user_tab_privs_recd;
-- No items to display

select owner, table_name, column_name, grantee, grantor, privilege
from user_col_privs;
-- Update on inf145407.pracownicy.placa_pod, inf145407.pracownicy.placa_dod

select table_name, column_name, grantee, grantor, privilege
from user_col_privs_made;
-- No items to display

select owner, table_name, column_name, grantor, privilege
from user_col_privs_recd; 
-- Update on inf145407.pracownicy.placa_pod, inf145407.pracownicy.placa_dod

-- Zadanie 9
-- użytkownik A
REVOKE UPDATE ON pracownicy FROM inf145256;

-- użytkownik B
UPDATE PRAC_RYSIU SET PLACA_DOD = 800;
-- ORA-00942: tabela lub perspektywa nie istnieje
UPDATE INF145407.PRACOWNICY SET PLACA_DOD = 700;
-- ORA-00942: tabela lub perspektywa nie istnieje

-- Zadanie 10
-- użytkownik A
CREATE ROLE ROLA_145256 IDENTIFIED BY pass123;
GRANT SELECT, UPDATE ON pracownicy TO ROLA_145256;

--użytkownik B
CREATE ROLE ROLA_145407;
GRANT SELECT, UPDATE ON PRACOWNICY TO ROLA_145407;

-- Zadanie 11
-- użytkownik A
GRANT ROLA_145256 TO inf145256;

-- użytkownik B
SELECT * FROM INF145407.PRACOWNICY;
-- ORA-00942: tabela lub perspektywa nie istnieje

-- Zadanie 12
-- użytkownik B
SET ROLE ROLA_145256 IDENTIFIED BY pass123;
SELECT * FROM INF145407.PRACOWNICY;
-- uprawnienia działają

select granted_role, admin_option from user_role_privs
where username = 'INF145256';
-- rola 145256 admin_option NO
-- rola 145407 admin_option YES

select role, owner, table_name, column_name, privilege
from role_tab_privs; 
-- uprawnienia do SELECT, UPDATE dla ROLA_145256 i ROLA_145407

-- Zadanie 13
-- użytkownik A
REVOKE ROLA_145256 FROM inf145256;

-- użytkownik B
SELECT * FROM INF145407.PRACOWNICY;
-- ORA-00942: tabela lub perspektywa nie istnieje

-- Zadanie 14
-- użytkownik B
SELECT * FROM INF145407.PRACOWNICY;
-- ORA-00942: tabela lub perspektywa nie istnieje

-- zadanie 15
-- użytkownik A
UPDATE inf145256.pracownicy SET placa_pod = 420 WHERE id_prac = 140;
-- ORA-01031: niewystarczające uprawnienia

-- Zadanie 16
-- użytkownik B
GRANT ROLA_145407 TO INF145407;

-- użytkownik A
UPDATE inf145256.pracownicy SET placa_pod = 420 WHERE id_prac = 140;
-- ORA-01031: niewystarczające uprawnienia

-- zadanie 17
-- użytkownik A
UPDATE inf145256.pracownicy SET placa_pod = 420 WHERE id_prac = 130;
-- 1 row updated.

-- Zadanie 18
-- użytkownik B
REVOKE UPDATE ON PRACOWNICY FROM ROLA_145407;

-- użytkownik A
UPDATE inf145256.pracownicy SET placa_pod = 1420 WHERE id_prac = 130;
-- ORA-01031: niewystarczające uprawnienia

-- Zadanie 19
-- użytkownik A
DROP ROLE ROLA_145256;
-- Role ROLA_145256 dropped.
-- użytkownik B
DROP ROLE ROLA_145407;
-- Role ROLA_145407 dropped.

-- Zadanie 20
-- użytkownik A
GRANT SELECT ON PRACOWNICY TO INF145256 WITH GRANT OPTION;

-- użytkownik B
GRANT SELECT ON INF145407.PRACOWNICY TO INF144566 WITH GRANT OPTION;

-- użytkownik C
SELECT * FROM INF145407.PRACOWNICY;
-- uprawnienia działają

-- Zadanie 21
-- go to zadanie 8

-- Zadanie 22
-- użytkownik A
REVOKE SELECT ON PRACOWNICY FROM INF144566;
-- ORA-01927: cannot REVOKE privileges you did not grant

REVOKE SELECT ON PRACOWNICY FROM INF145256;
-- Revoke succeeded.

-- odebranie uprawnień użytkownikowi B spowodowało kaskadowe cofnięcie uprawnień użytkownikowi C 

-- Zadadnie 23
-- użytkownik A
CREATE VIEW prac20 AS
    SELECT NAZWISKO, PLACA_POD, PLACA_DOD
    FROM PRACOWNICY
    WHERE ID_ZESP = 20;

-- REVOKE SELECT, UPDATE ON PRACOWNICY FROM INF145347; - jeżeli istnieją
GRANT SELECT, UPDATE ON prac20 TO INF145256;

-- użytkownik B
UPDATE inf145407.prac20 SET placa_pod = 1000 WHERE nazwisko = 'KOSZLAJDA';
-- operacja powiodła się

-- użytkownik A
SELECT * FROM prac20;

-- Zadanie 24
CREATE OR REPLACE FUNCTION funLiczEtaty
    RETURN NUMBER 
    IS
    vLbEtatow NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vLbEtatow
    FROM ETATY;

    RETURN vLbEtatow;
END;


GRANT EXECUTE ON funLiczEtaty TO INF145256;

-- Zadanie 25
-- użytkownik B
DECLARE
    vLiczba NUMBER;
BEGIN
    vLiczba := INF145407.funLiczEtaty();
    DBMS_OUTPUT.PUT_LINE(vLiczba);
END;
-- Wynik: 7

SELECT COUNT(*) FROM INF145407.ETATY;
-- ORA-00942: table or view does not exist
-- Mimo braku uprawnień, dane się zgadzają, użytkownik A posiada 7 rekordów w relacji ETATY

-- Zadanie 26
-- użytkownik A
CREATE OR REPLACE FUNCTION funLiczEtaty
    RETURN NUMBER 
    AUTHID CURRENT_USER
    IS
    vLbEtatow NUMBER := 0;
BEGIN
    SELECT COUNT(*) INTO vLbEtatow
    FROM ETATY;

    RETURN vLbEtatow;
END;

GRANT EXECUTE ON funLiczEtaty TO INF145256;

-- Zadanie 27
-- użytkownik B
DECLARE
vLiczba NUMBER;
BEGIN
vLiczba := INF145407.funLiczEtaty();
DBMS_OUTPUT.PUT_LINE(vLiczba);
END;
-- Wynik: 6
-- Dodanie AUTHID CURRENT_USER powoduje wywołanie zapytania wewnątrz funkcji na relacji ETATY użytkownika,
-- który uruchomił funkcję, a nie użytkownika, który te funkcje stworzył

-- Zadanie 28
-- użytkownik A
INSERT INTO ETATY(NAZWA, PLACA_MIN, PLACA_MAX) 
VALUES('WYKŁADOWC', 1000, 2000);
COMMIT;

-- Zadanie 29
-- użytkownik B
DECLARE
vLiczba NUMBER;
BEGIN
vLiczba := INF145407.funLiczEtaty();
DBMS_OUTPUT.PUT_LINE(vLiczba);
END;
-- (To zachowanie zostało już zaobserwowane w zadaniu wcześniejszym, ponieważ użytkownik A miał już inne zmiany w relacji ETATY)
-- Dodanie AUTHID CURRENT_USER powoduje wywołanie zapytania wewnątrz funkcji na relacji ETATY użytkownika,
-- który uruchomił funkcję, a nie użytkownika, który te funkcje stworzył

-- Zadanie 30
-- użytkownik B
CREATE TABLE test (
    id NUMBER(2),
    tekst VARCHAR2(20)
);

INSERT INTO TEST(ID, TEKST) VALUES(1,'pierwszy');
INSERT INTO TEST(ID, TEKST) VALUES(2,'drugi');

CREATE OR REPLACE PROCEDURE procPokazTest
AUTHID CURRENT_USER
IS
  CURSOR testTeksty IS SELECT tekst FROM test;
BEGIN
    FOR testTekst IN testTeksty LOOP
        DBMS_OUTPUT.PUT_LINE(testTekst.tekst);
    END LOOP;
END;

GRANT EXECUTE ON procPokazTest TO INF145407;
GRANT SELECT ON TEST TO INF145407;

-- Zadanie 31
-- użytkownik A
BEGIN
    INF145256.procPokazTest;
END;
-- Procedura próbuje odwołać siędo relacji TEST, której użytkownik A nie posiada
-- (spowodowane jest to klauzulą AUTHID CURRENT_USER i brakiem użycia 'B'.test w procedurze)
-- Wystarczy poprzedzić odwołanie do relacji TEST w procedurze odpowiednią nazwą użytkownika:
CREATE OR REPLACE PROCEDURE procPokazTest
AUTHID CURRENT_USER
IS
  CURSOR testTeksty IS SELECT tekst FROM INF145256.test;
BEGIN
    FOR testTekst IN testTeksty LOOP
        DBMS_OUTPUT.PUT_LINE(testTekst.tekst);
    END LOOP;
END;


-- Zadanie 32
CREATE TABLE info_dla_znajomych (
    NAZWA VARCHAR2(20) NOT NULL,
    INFO VARCHAR2(200) NOT NULL
);

INSERT INTO info_dla_znajomych(nazwa, info) 
VALUES('INF145407','Jakas tam zawartosc dla Rysia');

INSERT INTO info_dla_znajomych(nazwa, info) 
VALUES('INF144566','Jakas tam zawartosc dla Jasia');

INSERT INTO info_dla_znajomych(nazwa, info) 
VALUES('INF145256','Jakas tam zawartosc dla Natalii');

CREATE OR REPLACE VIEW info4u AS
    SELECT * 
    FROM inf145407.info_dla_znajomych
    WHERE NAZWA = USER;

GRANT SELECT ON info4u TO PUBLIC;
SELECT * FROM inf145407.info4u;
-- polecenie działa poprawnie dla różnych użytkowników