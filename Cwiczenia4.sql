--Cwiczenia 4

--1 Odczytaj aktualn¹ wartoœæ SCN.
select dbms_flashback.get_system_change_number FROM dual;
--1967547

--2 Utwórz tabele pracownicy
CREATE TABLE Pracownicy
(
    prac_id NUMBER(6) PRIMARY KEY,
    imie VARCHAR2(20),
    nazwisko VARCHAR(25)
);

--3 Wstaw do tabeli pracownicy przyk³adowe dane (6 wierszy). ZatwierdŸ operacje
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (1,'Adam','Nowak');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (2,'Tadeusz','Kania');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (3,'Arek','Kowal');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (4,'Waldek','Kiepski');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (5,'Pawel','Koziol');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (6,'Ryszard','Zajac');
COMMIT;

--4 Ponownie odczytaj wartoœæ SCN
select dbms_flashback.get_system_change_number FROM dual;
--1967951

--5 Usuñ 4 i 5 wiersz z tabeli pracownicy. ZatwierdŸ operacje. Wyœwietl zawartoœæ tabeli
DELETE FROM Pracownicy WHERE prac_id IN (4,5);
COMMIT;

--6 Wyœwietl pocz¹tkow¹ zawartoœæ tabeli pracownicy wykorzystuj¹c z SCN
SELECT * FROM Pracownicy AS OF SCN 1967951;

--7  Dopisz kolejne dwa wiersze do tabeli. ZatwierdŸ operacje. Wyœwietl zawartoœæ tabeli
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (7,'Waldek','King');
INSERT INTO Pracownicy (prac_id,imie,nazwisko) VALUES (8,'Franz','Smuda');
COMMIT;

--8 Wyœwietl zawartoœæ tabeli pracownicy wskazuj¹c dok³adny czas w przesz³oœci (np. 2 minuty wczeœniej).
SELECT * FROM Pracownicy AS OF TIMESTAMP (sysdate - 2/(24*60));

--9 Odczytaj aktualn¹ wartoœæ SCN.
select dbms_flashback.get_system_change_number FROM dual;
--1973269

--10  Zmodyfikuj zawartoœæ jednego wiersza tabeli pracownicy. ZatwierdŸ zmianê.
UPDATE Pracownicy SET Nazwisko='Kowalski' WHERE prac_id=1;
COMMIT;

--11 Ponownie zmodyfikuj zawartoœæ wybranego wiersza tabeli pracownicy. ZatwierdŸ zmianê
UPDATE Pracownicy SET Imie='Lukasz' WHERE prac_id=1;
COMMIT;

--12 Wyœwietl wszystkie wersje modyfikowanego w poprzednim zadaniu wiersza w tabeli.
SELECT * FROM Pracownicy versions between scn minvalue and maxvalue WHERE prac_id=1;

--13 Zmodyfikuj powy¿sze zapytanie aby wyœwietla³o rodzaj operacji i SCN/moment zmiany danych (pocz¹tek i koniec)
SELECT prac_id, imie, nazwisko, versions_operation, versions_starttime, versions_endtime FROM Pracownicy versions between scn minvalue and maxvalue WHERE prac_id=1;

--14 Wyœwietl zawartoœæ tabeli pracownicy sprzed 3 minut.
SELECT * FROM Pracownicy AS OF TIMESTAMP (sysdate - 3/(24*60));

--15 Utwórz tabele prachistoria zawieraj¹c¹ dane z tabeli pracownicy sprzed 5 minut.
CREATE TABLE PracHistoria AS (SELECT * FROM Pracownicy AS OF TIMESTAMP (sysdate - 5/(24*60)));

--16 SELECT dbms_flashback.get_system_change_number FROM dual;
SELECT dbms_flashback.get_system_change_number FROM dual;
--1976288

--17 Usuñ kolumnê imiê z tabeli prachistoria. Wyœwietl zawartoœæ tabeli
ALTER TABLE PracHistoria DROP COLUMN imie;

--18 Czy mo¿esz wyœwietliæ zawartoœci tabeli prachistoria sprzed usuniêcia kolumny?
SELECT * FROM PracHistoria AS OF SCN 1976288;
--unable to read data - table definition has changed

--19 Usuñ tabele prachistoria
DROP TABLE PracHistoria;

--20 SprawdŸ zawartoœæ kosza
SELECT * FROM recyclebin;

--21 Przywróæ tabelê prachistoria. 
flashback table PracHistoria to before drop;

--22 Usuñ tabele prachistoria z pominiêciem kosza. SprawdŸ zawartoœæ kosza.
drop table PracHistoria purge;

--23 Utwórz tabele produkty i usuñ j¹
CREATE TABLE Produkty (produkt_id NUMBER(6) PRIMARY KEY);
DROP TABLE Produkty;

--24 SprawdŸ zawartoœæ kosza.
SELECT * FROM recyclebin;

--25  Opró¿nij kosz. 
purge recyclebin;

--26  Przywróæ pocz¹tkow¹ wersjê tabeli pracownicy
ALTER TABLE Pracownicy ENABLE ROW MOVEMENT; --Aby stosowaæ mechanizm Flashback Table nale¿y uaktywniæ mechanizm ROW MOVEMENT
flashback table Pracownicy to scn 1967951;
