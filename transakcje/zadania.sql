-- bez tego polecenia wszystkie operacje są automatycznie zatwierdzane
SET AUTOCOMMIT OFF;

-- Transakcje DML
SET TRANSACTION NAME 'zadanie_1';

UPDATE pracownicy SET etat = 'ADIUNKT' WHERE nazwisko = 'MATYSIAK';

DELETE FROM pracownicy WHERE etat = 'ASYSTENT';

SELECT * FROM pracownicy;
-- zmiany zawartości się dokonały

ROLLBACK;

SELECT * FROM pracownicy;
-- zmiany zostały wycofane

-- Transakcje DDL
SET TRANSACTION NAME 'zadanie_2';

SELECT * FROM pracownicy WHERE etat='ADIUNKT';
UPDATE pracownicy SET placa_pod = (placa_pod + (placa_pod * 0.1)) WHERE etat = 'ADIUNKT';
SELECT * FROM pracownicy WHERE etat='ADIUNKT';
-- operacja została poprawnie wykonana

ALTER TABLE pracownicy
MODIFY placa_dod NUMBER(7,2);

ROLLBACK;
-- operacja ROLLBACK nie przywróciła stanu sprzed aktualizacji płac, ponieważ ALTER TABLE automatycznie wywołało COMMIT

-- Punkty bezpieczeństwa transakcji
SET TRANSACTION NAME 'zadanie_3';

UPDATE pracownicy SET placa_dod = COALESCE(placa_dod, 0) + 200;

SAVEPOINT S1;

UPDATE pracownicy SET placa_dod = 100 WHERE nazwisko = 'BIALY';

SAVEPOINT S2;

DELETE FROM pracownicy WHERE nazwisko = 'JEZIERSKI';

ROLLBACK TO SAVEPOINT S1;

SELECT * FROM pracownicy;

ROLLBACK TO SAVEPOINT S2;
-- ORA-01086: savepoint 'S2' never established in this session or is invalid
-- operacja nie powiodła się, ponieważ nie można cofnąć się do punktu, który nie został jeszcze utworzony
-- (utworzenie punktu S2 znajduje się po utworzeniu punktu S1, a w tym momencie transakcja znajdowała się w punkcie S1)

ROLLBACK;