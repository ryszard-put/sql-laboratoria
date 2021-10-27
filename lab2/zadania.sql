-- Zadanie 1
CREATE OR REPLACE PROCEDURE NowyPracownik
  (pNazwisko IN PRACOWNICY.NAZWISKO%TYPE,
  pZespol IN ZESPOLY.NAZWA%TYPE,
  pNazwiskoSzefa IN PRACOWNICY.NAZWISKO%TYPE,
  pPlacaPod IN PRACOWNICY.PLACA_POD%TYPE)
IS
  vIdPrac PRACOWNICY.ID_PRAC%TYPE;
  vIdSzefa PRACOWNICY.ID_PRAC%TYPE;
  vData PRACOWNICY.ZATRUDNIONY%TYPE;
  vIdZespolu PRACOWNICY.ID_ZESP%TYPE;
BEGIN
  SELECT PRAC_SEQ.NEXTVAL INTO vIdPrac FROM DUAL;
  SELECT ID_PRAC INTO vIdSzefa FROM PRACOWNICY WHERE NAZWISKO LIKE pNazwiskoSzefa;
  SELECT SYSDATE INTO vData FROM DUAL;
  SELECT ID_ZESP INTO vIdZespolu FROM ZESPOLY WHERE NAZWA = pZespol;

  INSERT INTO PRACOWNICY (ID_PRAC, NAZWISKO, ETAT, ID_SZEFA, ZATRUDNIONY, PLACA_POD, ID_ZESP)
  VALUES (vIdPrac, pNazwisko, 'STAZYSTA', vIdSzefa, vData, pPlacaPod, vIdZespolu);
END NowyPracownik;

-- Zadanie 2
CREATE OR REPLACE function PlacaNetto(
  pBrutto pracownicy.placa_pod%type,
  pPodatek number
) return pracownicy.placa_pod%type
is
begin
  return pBrutto / (1 + pPodatek / 100);
end;

-- Zadanie 3
CREATE OR REPLACE FUNCTION Silnia(
  pLiczba NUMBER
) RETURN NUMBER IS
  vSilnia NUMBER := 1;
BEGIN
  FOR vIterator IN 2..pLiczba LOOP
    vSilnia := vSilnia * vIterator;
  END LOOP;
  RETURN vSilnia;
END;

SELECT Silnia (8) FROM DUAL;

-- Zadanie 4
CREATE OR REPLACE FUNCTION SilniaRek(
  pLiczba NUMBER
) RETURN NUMBER IS
BEGIN
  IF pLiczba = 2 THEN
    RETURN pLiczba;
  END IF;
  RETURN pLiczba * SilniaRek(pLiczba - 1);
END;

SELECT SilniaRek(10) FROM DUAL;

-- Zadanie 5
CREATE OR REPLACE FUNCTION IleLat(
  pData DATE
) RETURN NUMBER IS
  vWynik NUMBER;
BEGIN
  SELECT ABS(MONTHS_BETWEEN(SYSDATE, pData)) INTO vWynik FROM DUAL;
  RETURN FLOOR(vWynik / 12);
END;

SELECT nazwisko, zatrudniony, IleLat(zatrudniony) AS staz
 FROM Pracownicy WHERE placa_pod > 1000
 ORDER BY nazwisko;

-- Zadanie 6
CREATE OR REPLACE PACKAGE Konwersja IS
  FUNCTION Cels_To_Fahr(
    pCels NUMBER
  ) RETURN NUMBER;
  FUNCTION Fahr_To_Cels(
    pFahr NUMBER
  ) RETURN NUMBER;
END Konwersja;

CREATE OR REPLACE PACKAGE BODY Konwersja IS
  FUNCTION Cels_To_Fahr(
    pCels NUMBER
  ) RETURN NUMBER IS
  BEGIN
    RETURN (9 * pCels / 5) + 32;
  END;

  FUNCTION Fahr_To_Cels(
    pFahr NUMBER
  ) RETURN NUMBER IS
  BEGIN
    RETURN (5 / 9) * (pFahr - 32);
  END;
END Konwersja;

SELECT Konwersja.Fahr_To_Cels(212) AS CELSJUSZ FROM Dual;
SELECT Konwersja.Cels_To_Fahr(0) AS FAHRENHEIT FROM Dual;

-- Zadanie 7
CREATE OR REPLACE PACKAGE Zmienne IS
  vLicznik NUMBER := 0;
  PROCEDURE ZwiekszLicznik;
  PROCEDURE ZmniejszLicznik;
  FUNCTION PokazLicznik RETURN vLicznik%TYPE;
END Zmienne;

CREATE OR REPLACE PACKAGE BODY Zmienne IS
  PROCEDURE ZwiekszLicznik IS
  BEGIN
    vLicznik := vLicznik + 1;
    DBMS_OUTPUT.PUT_LINE('Zwiekszono');
  END;
  PROCEDURE ZmniejszLicznik IS
  BEGIN
    vLicznik := vLicznik - 1;
    DBMS_OUTPUT.PUT_LINE('Zmniejszono');
  END;
  FUNCTION PokazLicznik RETURN vLicznik%TYPE IS BEGIN RETURN vLicznik; END;
BEGIN
  vLicznik := 1;
  DBMS_OUTPUT.PUT_LINE('Zainicjalizowano');
END Zmienne;


create sequence zesp_seq start with 60 increment by 10;

-- Zadanie 8
CREATE OR REPLACE PACKAGE IntZespoly IS
    PROCEDURE DodajZespol(
        pNazwa zespoly.nazwa%type,
        pAdres zespoly.adres%type
    );
    PROCEDURE UsunZespolId(
        pIdZesp zespoly.id_zesp%type
    );
    PROCEDURE UsunZespolNazwa(
        pNazwa zespoly.nazwa%type
    );
    PROCEDURE ModyfikujZespol(
        pIdZesp zespoly.id_zesp%type,
        pNazwa zespoly.nazwa%type,
        pAdres zespoly.adres%type
    );
    FUNCTION ZnajdzIdZespolu( pNazwa zespoly.nazwa%type ) RETURN zespoly.id_zesp%type;
    FUNCTION ZnajdzNazweZespolu( pIdZesp zespoly.id_zesp%type ) RETURN zespoly.nazwa%type;
    FUNCTION ZnajdzAdresZespolu( pIdZesp zespoly.id_zesp%type ) RETURN zespoly.adres%type;
END IntZespoly;

CREATE OR REPLACE PACKAGE BODY IntZespoly IS
    PROCEDURE DodajZespol(
        pNazwa zespoly.nazwa%type,
        pAdres zespoly.adres%type
    ) IS
    BEGIN
        INSERT INTO zespoly (id_zesp, nazwa, adres)
        VALUES (zesp_seq.nextval, pNazwa, pAdres);
    END;

    PROCEDURE UsunZespolId(
        pIdZesp zespoly.id_zesp%type
    ) IS
    BEGIN
        DELETE FROM zespoly
        WHERE id_zesp = pIdZesp;
    END;

    PROCEDURE UsunZespolNazwa(
        pNazwa zespoly.nazwa%type
    ) IS
    BEGIN
        DELETE FROM zespoly
        WHERE nazwa = pNazwa;
    END;

    PROCEDURE ModyfikujZespol(
        pIdZesp zespoly.id_zesp%type,
        pNazwa zespoly.nazwa%type,
        pAdres zespoly.adres%type
    ) IS
    BEGIN
        UPDATE zespoly
        SET
            nazwa = pNazwa,
            adres = pAdres
        WHERE id_zesp = pIdZesp;
    END;

    FUNCTION ZnajdzIdZespolu(
        pNazwa zespoly.nazwa%type
    ) RETURN zespoly.id_zesp%type IS
        vIdZesp zespoly.id_zesp%type;
    BEGIN
        SELECT ID_ZESP INTO vIdZesp FROM zespoly WHERE nazwa = pNazwa;
        RETURN vIdZesp;
    END;

    FUNCTION ZnajdzNazweZespolu(
        pIdZesp zespoly.id_zesp%type
    ) RETURN zespoly.nazwa%type IS
        vNazwa zespoly.nazwa%type;
    BEGIN
        SELECT nazwa INTO vNazwa FROM zespoly WHERE id_zesp = pIdZesp;
        RETURN vNazwa; 
    END;

    FUNCTION ZnajdzAdresZespolu(
        pIdZesp zespoly.id_zesp%type
    ) RETURN zespoly.adres%type IS
        vAdres zespoly.adres%type;
    BEGIN
        SELECT adres INTO vAdres FROM zespoly WHERE id_zesp = pIdZesp;
        RETURN vAdres;
    END;
END IntZespoly;

-- Zadanie 9
SELECT object_name, object_type, status
FROM User_Objects
WHERE object_type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE');

-- Zadanie 10
BEGIN
    DROP FUNCTION Silnia;
    DROP FUNCTION SilniaRek;
    DROP FUNCTION IleLat;
END;

-- Zadanie 11
DROP PACKAGE Konwersja;




