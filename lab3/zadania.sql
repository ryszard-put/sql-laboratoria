-- zadanie 1
-- na laptopie
-- zadanie 2
-- na laptopie

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

