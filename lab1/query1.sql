-- Zadanie 1-2
DECLARE
  vTekst VARCHAR(100) := 'Witaj, świecie!' || ' Witaj, nowy dniu!';
  vLiczba NUMBER := 1000.456 + POWER(10,15);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Zmienna vTekst: ' || vTekst);
  DBMS_OUTPUT.PUT_LINE('Zmienna vLiczba: ' || vLiczba);
END;

-- Zadanie 3
DECLARE
  vLiczba1 NUMBER := 10.2356000;
  vLiczba2 NUMBER :=  0.0000001;
  vSuma NUMBER;
BEGIN
  vSuma := vLiczba1 + vLiczba2;
  DBMS_OUTPUT.PUT_LINE('Wynik dodawania ' || vLiczba1 || ' i ' || vLiczba2 || ': ' || vSuma);
END;

-- Zadanie 4
DECLARE
  cPI CONSTANT NUMBER(3, 2) := 3.14;
  vPromien NUMBER := 5;
  vObwod NUMBER;
  vPole NUMBER;
BEGIN
  vObwod := 2 * cPI * vPromien;
  vPole := cPI * POWER(vPromien, 2);
  DBMS_OUTPUT.PUT_LINE('Obwód koła o promieniu równym ' || vPromien || ': ' || vObwod);
  DBMS_OUTPUT.PUT_LINE('Pole koła o promieniu równym ' || vPromien || ': ' || vPole);
END;

-- Zadanie 5
DECLARE
  vNazwisko PRACOWNICY.NAZWISKO%TYPE;
  vEtat PRACOWNICY.ETAT%TYPE;
BEGIN
  SELECT NAZWISKO, ETAT
  INTO vNazwisko, vEtat
  FROM PRACOWNICY
  WHERE PLACA_POD + PLACA_DOD = (
    SELECT MAX(PLACA_POD + PLACA_DOD)
    FROM PRACOWNICY
  );
  DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik ' || vNazwisko);
  DBMS_OUTPUT.PUT_LINE('Pracuje on jako ' || vEtat);
END;

-- Zadanie 6
DECLARE
  vPracownik PRACOWNICY%ROWTYPE;
BEGIN
  SELECT *
  INTO vPracownik
  FROM PRACOWNICY
  WHERE PLACA_POD + PLACA_DOD = (
    SELECT MAX(PLACA_POD + PLACA_DOD)
    FROM PRACOWNICY
  );
  DBMS_OUTPUT.PUT_LINE('Najlepiej zarabia pracownik ' || vPracownik.nazwisko);
  DBMS_OUTPUT.PUT_LINE('Pracuje on jako ' || vPracownik.etat);
END;

-- Zadanie 7
DECLARE
  vNazwisko VARCHAR(20) := 'SLOWINSKI';
  SUBTYPE tPieniadze IS NUMBER;
  vPieniadze tPieniadze;
BEGIN
  SELECT (12 * (PLACA_POD + COALESCE(PLACA_DOD, 0)))
  INTO vPieniadze
  FROM PRACOWNICY
  WHERE NAZWISKO LIKE vNazwisko;
  DBMS_OUTPUT.PUT_LINE('Pracownik ' || vNazwisko || ' zarabia rocznie ' || vPieniadze);
END;

-- Zadanie 8
DECLARE
  vSekunda TIMESTAMP;
BEGIN
  LOOP
    SELECT SYSDATE INTO vSekunda FROM DUAL;
    EXIT WHEN TO_CHAR(vSekunda, 'SS') = '25';
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Nadeszla 25 sekunda');
END;

-- Zadanie 9
DECLARE
  vLiczba NUMBER := 10;
  vSilnia NUMBER := 1;
BEGIN
  FOR vIndex IN 1..vLiczba LOOP
    vSilnia := vSilnia * vIndex;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Silnia dla n=' || vLiczba || ': ' || vSilnia);
END;

-- Zadanie 10
DECLARE
  vDataPoczatkowa DATE := TO_DATE('01-01-2001', 'dd-mm-yyyy');
  vDataKoncowa DATE := TO_DATE('31-12-2100', 'dd-mm-yyyy');
  vStart NUMBER;
  vKoniec NUMBER;
  vData DATE;
BEGIN
  vStart := TO_NUMBER(TO_CHAR(vDataPoczatkowa, 'j'));
  vKoniec := TO_NUMBER(TO_CHAR(vDataKoncowa, 'j'));
  FOR vIterator IN vStart..vKoniec LOOP
    vData := TO_DATE(vIterator, 'j');
    IF TO_CHAR(vData, 'DD') = '13' AND TO_CHAR(vData, 'DAY') LIKE '%FRIDAY%' THEN
      DBMS_OUTPUT.PUT_LINE(TO_CHAR(vData, 'dd-mm-yyyy'));
    END IF;
  END LOOP;
END;