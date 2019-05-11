--Cwiczenia 4

--1 Odczytaj aktualn� warto�� SCN.
select dbms_flashback.get_system_change_number FROM dual;
--1967547

--2 Utw�rz tabele pracownicy
CREATE TABLE Pracownicy
(
    prac_id NUMBER(6) PRIMARY KEY,
    imie VARCHAR2(20),
    nazwisko VARCHAR(25)
);

--3 Wstaw do tabeli pracownicy przyk�adowe dane (6 wierszy). Zatwierd� operacje
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (1,'Adam','Nowak');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (2,'Tadeusz','Kania');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (3,'Arek','Kowal');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (4,'Waldek','Kiepski');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (5,'Pawel','Koziol');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (6,'Ryszard','Zajac');
COMMIT;

--4 Ponownie odczytaj warto�� SCN
select dbms_flashback.get_system_change_number FROM dual;
--1967951

--5 Usu� 4 i 5 wiersz z tabeli pracownicy. Zatwierd� operacje. Wy�wietl zawarto�� tabeli
DELETE FROM Pracownicy WHERE prac_id IN (4,5);
COMMIT;

--6 Wy�wietl pocz�tkow� zawarto�� tabeli pracownicy wykorzystuj�c z SCN
SELECT * FROM Pracownicy AS OF SCN 1967951;

--7  Dopisz kolejne dwa wiersze do tabeli. Zatwierd� operacje. Wy�wietl zawarto�� tabeli
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (7,'Waldek','King');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (8,'Franz','Smuda');
COMMIT;

--8 Wy�wietl zawarto�� tabeli pracownicy wskazuj�c dok�adny czas w przesz�o�ci (np. 2 minuty wcze�niej).
SELECT * FROM Pracownicy AS OF TIMESTAMP (sysdate - 2/(24*60));

--9 Odczytaj aktualn� warto�� SCN.
select dbms_flashback.get_system_change_number FROM dual;
--1973269

--10  Zmodyfikuj zawarto�� jednego wiersza tabeli pracownicy. Zatwierd� zmian�.
UPDATE Pracownicy SET Nazwisko='Kowalski' WHERE prac_id=1;
COMMIT;

--11 Ponownie zmodyfikuj zawarto�� wybranego wiersza tabeli pracownicy. Zatwierd� zmian�
UPDATE Pracownicy SET Imie='Lukasz' WHERE prac_id=1;
COMMIT;

--12 Wy�wietl wszystkie wersje modyfikowanego w poprzednim zadaniu wiersza w tabeli.
SELECT * FROM Pracownicy versions between scn minvalue and maxvalue WHERE prac_id=1;

--13 Zmodyfikuj powy�sze zapytanie aby wy�wietla�o rodzaj operacji i SCN/moment zmiany danych (pocz�tek i koniec)
SELECT prac_id, imie, nazwisko, versions_operation, versions_starttime, versions_endtime FROM Pracownicy versions between scn minvalue and maxvalue WHERE prac_id=1;

--14 Wy�wietl zawarto�� tabeli pracownicy sprzed 3 minut.
SELECT * FROM Pracownicy AS OF TIMESTAMP (sysdate - 3/(24*60));

--15 Utw�rz tabele prachistoria zawieraj�c� dane z tabeli pracownicy sprzed 5 minut.
CREATE TABLE PracHistoria AS (SELECT * FROM Pracownicy AS OF TIMESTAMP (sysdate - 5/(24*60)));

--16 SELECT dbms_flashback.get_system_change_number FROM dual;
SELECT dbms_flashback.get_system_change_number FROM dual;
--1976288

--17 Usu� kolumn� imi� z tabeli prachistoria. Wy�wietl zawarto�� tabeli
ALTER TABLE PracHistoria DROP COLUMN imie;

--18 Czy mo�esz wy�wietli� zawarto�ci tabeli prachistoria sprzed usuni�cia kolumny?
SELECT * FROM PracHistoria AS OF SCN 1976288;
--unable to read data - table definition has changed

--19 Usu� tabele prachistoria
DROP TABLE PracHistoria;

--20 Sprawd� zawarto�� kosza
SELECT * FROM recyclebin;

--21 Przywr�� tabel� prachistoria. 
flashback table PracHistoria to before drop;

--22 Usu� tabele prachistoria z pomini�ciem kosza. Sprawd� zawarto�� kosza.
drop table PracHistoria purge;

--23 Utw�rz tabele produkty i usu� j�
CREATE TABLE Produkty (produkt_id NUMBER(6) PRIMARY KEY);
DROP TABLE Produkty;

--24 Sprawd� zawarto�� kosza.
SELECT * FROM recyclebin;

--25  Opr�nij kosz. 
purge recyclebin;

--26  Przywr�� pocz�tkow� wersj� tabeli pracownicy
ALTER TABLE Pracownicy ENABLE ROW MOVEMENT; --Aby stosowa� mechanizm Flashback Table nale�y uaktywni� mechanizm ROW MOVEMENT
flashback table Pracownicy to scn 1967951;
