-- Übungen: Hierarchische Queries

-- 1a. Schreiben Sie eine hierarchische Abfrage für die Mitarbeiter des 
-- Managers Mourgos, beginnend mit diesem. Es sollen die Nachnamen, Gehälter
-- und Abteilungsnummern der Mitarbeiter, sowie die Hierarchie-Ebene 
-- angezeigt werden.




-- 1b. Erweitern Sie die vorherige Ausgabe um Pfadangaben, die die
-- Hierarchie verdeutlichen.






-- 2 Zeigen Sie die Managerhierarchie BottomUp für den Mitarbeiter Lorentz an, 
-- beginnend mit dem direkten Vorgesetzten.





-- 3. Erzeugen Sie eine fortlaufende tagesweise Liste von Datumswerten,
-- beginnend mit dem Datum '2021-01-01' bis zum '2021-12-31'.
-- Leider ist bei SQL Server die Rekursionstiefe standardmäßig drastisch 
-- begrenzt!


/*
DT      
--------
01.01.21
02.01.21
03.01.21
04.01.21
05.01.21
06.01.21
...
*/




-- 4. Zeigen Sie die Mitarbeiterkennung, die Managerkennung, den Nachnamen, 
-- sowie die Ebene der Mitarbeiter an, die sich 2 Ebenen unter dem Mitarbeiter
-- De Haan befinden.





-- 5. Zeigen Sie die Managementhierarchie beginnend mit dem Mitarbeiter Kochhar
-- an (top-down). Geben Sie jeweils Nachname, Managerkennung und Abteilungs_
-- nummer der Mitarbeiter aus. Dabei sollen die Zeilen je Hierarchiestufe um 5
-- Positionen eingerückt werden und die Einrückung mit "_"-Zeichen verdeutlicht
-- werden (Hinweis: Verwenden Sie die REPLICATE-Funktion)







-- 6.Sportliche Aufgabe!!
-- Zeigen Sie die gesamte Managementhierarchie ohne Indianer topdown mit 
-- Mitarbeiterkennung, Managerkennung, Nachnamen, Ebene an 
-- und zusätzlich je Manager die Gesamtanzahl ihm unterstellter Mitarbeiter
-- (d.h. akkumuliert: Steven King hat bei 107 Mitarbeitern 106 unter sich)

/*
EMP_LAST        EID    MGR_ID     SALARY   SUM(CNT_EMPLOYEES)  MGRLEVEL
----------		---   ------     ------    ---                 --
King            100               24000    106					3
Cambrault       148       100     11000      7                  2
De Haan         102       100     17000      5                  2
Errazuriz       147       100     12000      6                  1
Fripp           121       100      8200      8                  1
Hartstein       201       100     13000      1                  1
Kaufling        122       100      7900      8                  1
. . .  
*/

