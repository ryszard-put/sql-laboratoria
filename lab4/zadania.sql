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

CREATE TRIGGER WymuszajPlace
 BEFORE INSERT OR UPDATE OF placa_pod ON Pracownicy
 FOR EACH ROW
 WHEN (NEW.etat IS NOT NULL)
DECLARE
 vPlacaMin Etaty.placa_min%TYPE;
 vPlacaMax Etaty.placa_max%TYPE;
BEGIN
 SELECT placa_min, placa_max
 INTO vPlacaMin, vPlacaMax
 FROM Etaty WHERE nazwa = :NEW.etat;
 IF :NEW.placa_pod NOT BETWEEN vPlacaMin AND vPlacaMax THEN
 RAISE_APPLICATION_ERROR(-20001, 'Płaca poza zakresem dla etatu!');
 END IF;
END;

