-- zadanie 1

DECLARE
  CURSOR cAsystenci IS
  SELECT nazwisko, zatrudniony
  FROM pracownicy
  WHERE ETAT = 'ASYSTENT';

  TYPE tAsystent IS RECORD(
    nazwisko pracownicy.nazwisko%type,
    zatrudniony pracownicy.zatrudniony%type
  );

  vAsystent tAsystent;
BEGIN
  OPEN cAsystenci;
  LOOP
    FETCH cAsystenci INTO vAsystent;
    EXIT WHEN cAsystenci%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(vAsystent.nazwisko || ' pracuje od ' || vAsystent.zatrudniony);
  END LOOP;
  CLOSE cAsystenci;
END;

-- zadanie 2

DECLARE
  CURSOR cNajlepsi IS
  SELECT NAZWISKO
  FROM PRACOWNICY
  ORDER BY placa_pod + COALESCE(placa_dod, 0) DESC;
BEGIN
  FOR vNajlepszy IN cNajlepsi LOOP
    EXIT WHEN 4 = cNajlepsi%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE(cNajlepsi%ROWCOUNT || ' : ' || vNajlepszy.nazwisko);
  END LOOP; 
END;

-- zadanie 3

DECLARE
  CURSOR cPodwyzka IS
  SELECT id_prac, nazwisko, placa_pod
  FROM pracownicy
  WHERE TO_CHAR(zatrudniony, 'd') = 2
  FOR UPDATE;
BEGIN
  FOR vPracownik IN cPodwyzka LOOP
    UPDATE PRACOWNICY
    SET placa_pod = (vPracownik.placa_pod + vPracownik.placa_pod * 0.2)
    WHERE id_prac = vPracownik.id_prac;
  END LOOP;
END;

-- zadanie 4

DECLARE
  CURSOR cBonusy IS
  SELECT
    id_prac,
    etat,
    nazwa,
    placa_dod,
    CASE nazwa
    WHEN 'ALGORYTMY' THEN 100
    WHEN 'ADMINISTRACJA' THEN 150
    ELSE -1 END AS bonus
  FROM pracownicy join zespoly using(id_zesp)
  FOR UPDATE OF id_prac;
BEGIN
  FOR vPracownik in cBonusy LOOP
    IF vPracownik.bonus = -1 AND vPracownik.etat = 'STAZYSTA' THEN
      DELETE FROM PRACOWNICY
      WHERE id_prac = vPracownik.id_prac;
    ELSIF vPracownik.bonus <> -1 THEN
      UPDATE PRACOWNICY
      SET placa_dod = COALESCE(vPracownik.placa_dod, 0) + vPracownik.bonus
      WHERE id_prac = vPracownik.id_prac;
    END IF;
  END LOOP;
END;

-- zadanie 5

CREATE OR REPLACE PROCEDURE PokazPracownikowEtatu(
  pEtat pracownicy.etat%type
) IS
  CURSOR cPracownicyEtatu(pNazwaEtatu pracownicy.etat%type) IS
  SELECT nazwisko FROM pracownicy
  WHERE etat = pNazwaEtatu
  ORDER BY 1;
BEGIN
  FOR vPracownik IN cPracownicyEtatu(pEtat) LOOP
    DBMS_OUTPUT.PUT_LINE(vPracownik.nazwisko);
  END LOOP;
END;

EXEC POKAZPRACOWNIKOWETATU(PETAT  => 'PROFESOR' /*IN VARCHAR2*/);

-- zadanie 6

CREATE OR REPLACE PROCEDURE RaportKadrowy IS
  CURSOR cEtaty IS
  SELECT nazwa
  FROM etaty
  ORDER BY 1;

  CURSOR cPracownicy(
    pEtat pracownicy.etat%type
  ) IS
  SELECT nazwisko, (placa_pod + COALESCE(placa_dod, 0)) AS pensja
  FROM pracownicy
  WHERE etat = pEtat
  ORDER BY 1;

  vSumaPensji NUMBER := 0;
  vLicznik NUMBER := 0;
BEGIN
  FOR vEtat IN cEtaty LOOP
    vSumaPensji := 0;
    vLicznik := 0;
    DBMS_OUTPUT.PUT_LINE('Etat: ' || vEtat.nazwa);
    DBMS_OUTPUT.PUT_LINE('------------------------------');
    FOR vPracownik IN cPracownicy(vEtat.nazwa) LOOP
      vLicznik := vLicznik + 1;
      vSumaPensji := vSumaPensji + vPracownik.pensja;
      DBMS_OUTPUT.PUT_LINE(cPracownicy%ROWCOUNT || '. ' || vPracownik.nazwisko || ', pensja: ' || vPracownik.pensja);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Liczba pracownikow: ' || vLicznik);
    IF vLicznik = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Średnia pensja: brak');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Średnia pensja: ' || (vSumaPensji / vLicznik));
    END IF;
    DBMS_OUTPUT.PUT_LINE(' ');
  END LOOP;
END;

EXEC RaportKadrowy;

