-- zadanie 1

CREATE TABLE DziennikOperacji(
  id_operacji NUMBER(6) NOT NULL,
  wykonano DATE NOT NULL,
  typ VARCHAR2(6) NOT NULL,
  tabela VARCHAR(20) NOT NULL,
  liczba_rekordow NUMBER(6) NOT NULL
);

CREATE SEQUENCE DziennikOperacji_seq
START WITH 1
INCREMENT BY 1
NOCYCLE;

CREATE OR REPLACE TRIGGER LogujOperacje
  AFTER INSERT OR UPDATE OR DELETE ON zespoly
DECLARE
  vLiczbaRekordow DziennikOperacji.liczba_rekordow%TYPE;
  vDataWykonania DziennikOperacji.wykonano%TYPE;
  vTyp DziennikOperacji.typ%TYPE;
  vTabela DziennikOperacji.tabela%TYPE := 'ZESPOLY';
BEGIN
  SELECT SYSDATE INTO vDataWykonania FROM DUAL;
  SELECT COUNT(*) INTO vLiczbaRekordow FROM ZESPOLY;
  CASE
    WHEN UPDATING THEN
      vTyp := 'UPDATE';
    WHEN DELETING THEN
      vTyp := 'DELETE';
    WHEN INSERTING THEN
      vTyp := 'INSERT';
  END CASE;

  INSERT INTO DziennikOperacji
  VALUES(DziennikOperacji_seq.nextval, vDataWykonania, vTyp, vTabela, vLiczbaRekordow);
END;

UPDATE ZESPOLY
SET adres = 'PIOTROWO 2A'
WHERE id_zesp = 10;

-- zadanie 2

CREATE OR REPLACE TRIGGER PokazPlace
  BEFORE UPDATE OF placa_pod ON Pracownicy
  FOR EACH ROW
  WHEN
    (OLD.placa_pod <> NEW.placa_pod) OR
    (NEW.placa_pod IS NULL) OR
    ((OLD.placa_pod IS NULL) AND (NEW.placa_pod IS NOT NULL))
BEGIN
  DBMS_OUTPUT.PUT_LINE('Pracownik ' || :OLD.nazwisko);
  DBMS_OUTPUT.PUT_LINE('Płaca przed modyfikacją: ' || :OLD.placa_pod);
  DBMS_OUTPUT.PUT_LINE('Płaca po modyfikacji: ' || :NEW.placa_pod);
END;

-- zadanie 3
CREATE OR REPLACE TRIGGER UzupelnijPlace
  BEFORE INSERT ON pracownicy
  FOR EACH ROW
  WHEN (NEW.placa_pod IS NULL OR NEW.placa_dod IS NULL)
DECLARE
  vPlacaPod pracownicy.placa_pod%type;
BEGIN
  IF :NEW.ETAT IS NOT NULL AND :NEW.placa_pod IS NULL THEN
    SELECT placa_min INTO vPlacaPod
    FROM ETATY
    WHERE :NEW.etat = nazwa;
    :NEW.placa_pod := vPlacaPod;
  END IF;
  IF :NEW.placa_dod IS NULL THEN
    :NEW.placa_dod := 0;
  END IF;
END;

-- zadanie 4
CREATE OR REPLACE TRIGGER UzupelnijId
  BEFORE INSERT ON zespoly
  FOR EACH ROW
  WHEN (NEW.id_zesp IS NULL)
BEGIN
  :NEW.id_zesp := zesp_seq.nextval;
END;

-- zadanie 5
CREATE OR REPLACE VIEW Szefowie
(szef, pracownicy)
  AS
SELECT
  nazwisko AS szef,
  (
    SELECT COUNT(id_szefa)
    FROM PRACOWNICY p
    WHERE p.id_szefa = s.id_prac
  ) AS pracownicy
FROM pracownicy s
WHERE EXISTS (SELECT id_prac FROM pracownicy p WHERE p.id_szefa = s.id_prac);

CREATE OR REPLACE TRIGGER UsuniecieSzefa
  INSTEAD OF DELETE ON Szefowie
DECLARE
  vPodwladniSzefowie NUMBER;
BEGIN
  SELECT COUNT(id_prac) INTO vPodwladniSzefowie
  FROM pracownicy
  WHERE id_szefa = (
    SELECT id_prac
    FROM pracownicy
    WHERE nazwisko = :OLD.szef
  ) AND nazwisko IN (SELECT szef FROM Szefowie);
  IF vPodwladniSzefowie > 0 THEN
    RAISE_APPLICATION_ERROR(
      -20001,
      'Jeden z podwładnych usuwanego pracownika jest szefem innych pracowników. Usuwanie anulowane!'
    );
  END IF;
  DELETE FROM pracownicy
  WHERE id_szefa = (
    SELECT id_prac FROM PRACOWNICY
    WHERE nazwisko = :OLD.szef
  );

  DELETE FROM PRACOWNICY
  WHERE nazwisko = :OLD.szef;
END;

-- zadanie 6
ALTER TABLE ZESPOLY ADD liczba_pracownikow NUMBER;

UPDATE ZESPOLY
SET
  liczba_pracownikow = (
    SELECT COUNT(id_prac) FROM PRACOWNICY WHERE pracownicy.id_zesp = zespoly.id_zesp
  );

SET AUTOCOMMIT ON;

CREATE OR REPLACE TRIGGER AktualizujZespoly
  AFTER INSERT OR UPDATE OR DELETE ON pracownicy
  FOR EACH ROW
  WHEN ((OLD.id_zesp <> NEW.id_zesp) OR (OLD.id_zesp IS NULL AND NEW.id_zesp IS NOT NULL) OR (OLD.id_zesp IS NOT NULL AND NEW.id_zesp IS NULL))
BEGIN
  IF INSERTING THEN
    UPDATE ZESPOLY
    SET liczba_pracownikow = liczba_pracownikow + 1
    WHERE id_zesp = :NEW.id_zesp;
  ELSIF UPDATING THEN
    UPDATE ZESPOLY
    SET liczba_pracownikow = liczba_pracownikow + 1
    WHERE id_zesp = :NEW.id_zesp;

    UPDATE ZESPOLY
    SET liczba_pracownikow = liczba_pracownikow - 1
    WHERE id_zesp = :OLD.id_zesp;
  ELSIF DELETING THEN
    UPDATE ZESPOLY
    SET liczba_pracownikow = liczba_pracownikow - 1
    WHERE id_zesp = :OLD.id_zesp;
  END IF;
END;

-- zadanie 7
ALTER TABLE pracownicy DROP CONSTRAINT FK_ID_SZEFA;
ALTER TABLE pracownicy
ADD CONSTRAINT FK_ID_SZEFA
  FOREIGN KEY (id_szefa)
  REFERENCES pracownicy (id_prac)
  ON DELETE CASCADE;


SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER Usun_Prac
  AFTER DELETE ON PRACOWNICY
  FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Usuwany pracownik: ' || :OLD.nazwisko);
END;


SELECT * FROM PRACOWNICY;
DELETE FROM PRACOWNICY WHERE id_prac = 130;
ROLLBACK;
-- Przy uzyciu AFTER usuniecie pracownika Brzezinski powoduje taki efekt:
-- Usuwany pracownik: KROLIKOWSKI
-- Usuwany pracownik: KOSZLAJDA
-- Usuwany pracownik: JEZIERSKI
-- Usuwany pracownik: MORZY
-- Usuwany pracownik: BRZEZINSKI

CREATE OR REPLACE TRIGGER Usun_Prac
  BEFORE DELETE ON PRACOWNICY
  FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('Usuwany pracownik: ' || :OLD.nazwisko);
END;

-- Przy uzyciu BEFORE usuniecie pracownika Brzezinski powoduje taki efekt:
-- Usuwany pracownik: BRZEZINSKI
-- Usuwany pracownik: MORZY
-- Usuwany pracownik: KROLIKOWSKI
-- Usuwany pracownik: KOSZLAJDA
-- Usuwany pracownik: JEZIERSKI