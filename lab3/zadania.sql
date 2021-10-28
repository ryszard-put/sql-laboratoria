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
