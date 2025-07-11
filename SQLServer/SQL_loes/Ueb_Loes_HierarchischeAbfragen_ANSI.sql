-- Übungen: Hierarchische Queries

-- 1a. Schreiben Sie eine hierarchische Abfrage für die Mitarbeiter des 
-- Managers Mourgos, beginnend mit diesem. Es sollen die Nachnamen, Gehälter
-- und Abteilungsnummern der Mitarbeiter, sowie die Hierarchie-Ebene 
-- angezeigt werden.

-- eid wird für Join benötigt
WITH rek_topdown( lname, sal, depid, level1, eid  ) AS 
    (   SELECT last_name, salary, department_id, 1, employee_id
        FROM employees WHERE last_name = 'Mourgos'
      UNION ALL
        SELECT e.last_name, e.salary, e.department_id, r.level1+1
		       , e.employee_id
        FROM employees e JOIN rek_topdown r ON e.manager_id = r.eid
    )
SELECT lname, sal, depid, level1
FROM rek_topdown;



-- 1b. Erweitern Sie die vorherige Ausgabe um Pfadangaben, die die
-- Hierarchie verdeutlichen.
WITH rek_topdown( lname, sal, depid, level1, eid, path1  ) AS  
    (   SELECT last_name, salary, department_id, 1, employee_id
        , CAST(last_name AS VARCHAR(max))	-- CAST ist notwendig!
        FROM employees WHERE last_name = 'Mourgos'
      UNION ALL
        SELECT e.last_name, e.salary, e.department_id
		       , r.level1+1, e.employee_id
               , r.path1 + '/' + e.last_name
        FROM employees e JOIN rek_topdown r ON e.manager_id = r.eid
    )
SELECT lname, sal, depid, level1, path1
FROM rek_topdown;





-- 2 Zeigen Sie die Managerhierarchie BottomUp für den Mitarbeiter Lorentz an, 
-- beginnend mit dem direkten Vorgesetzten.
WITH rek_bottomup( eid, lname, mgrid, path ) AS
  ( SELECT employee_id, last_name, manager_id, CAST(last_name AS VARCHAR(max))
        FROM employees WHERE last_name = 'Lorentz'
   UNION ALL
    SELECT e.employee_id, e.last_name, e.manager_id
           , e.last_name + '/' + r.path
        FROM employees e JOIN rek_bottomup r ON e.employee_id = r.mgrid
  )
SELECT eid, lname, mgrid, path
FROM rek_bottomup;





-- 3. Erzeugen Sie eine fortlaufende tagesweise Liste von Datumswerten,
-- beginnend mit dem Datum '2021-01-01' bis zum '2021-12-31'.
-- Leider ist bei SQL Server die Rekursionstiefe standardmäßig drastisch 
-- begrenzt!

WITH  my_dates(dt) AS 
    (
        SELECT CAST('2021-01-01' AS DATE)
      UNION ALL 
        SELECT DATEADD(day, 1, dt)   FROM my_dates   
            WHERE dt < '2021-12-31')
SELECT * FROM my_dates
OPTION (MAXRECURSION 500); -- damit klappt es zumindest für max. 500 Werte

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
WITH rek_topdown( eid, lname, mgrid, level1 ) AS  
    (   SELECT employee_id, last_name, manager_id, 1 
        FROM employees WHERE last_name = 'De Haan'                            
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id, r.level1+1
        FROM employees e JOIN rek_topdown r ON e.manager_id = r.eid 
    )
SELECT eid, lname, mgrid, level1
FROM rek_topdown 
WHERE level1 = 3;




-- 5. Zeigen Sie die Managementhierarchie beginnend mit dem Mitarbeiter Kochhar
-- an (top-down). Geben Sie jeweils Nachname, Managerkennung und Abteilungs_
-- nummer der Mitarbeiter aus. Dabei sollen die Zeilen je Hierarchiestufe um 5
-- Positionen eingerückt werden und die Einrückung mit "_"-Zeichen verdeutlicht
-- werden (Hinweis: Verwenden Sie die REPLICATE-Funktion)


WITH rek_topdown( lname, mgrid, depid, level1, eid  ) AS
    (   SELECT last_name, manager_id, department_id, 1, employee_id
        FROM employees WHERE last_name = 'Kochhar'
      UNION ALL
        SELECT e.last_name, e.manager_id, e.department_id
		       , r.level1+1, e.employee_id
        FROM employees e JOIN rek_topdown r ON e.manager_id = r.eid
    )
SELECT REPLICATE('__', (level1-1)) + lname "Lastname", mgrid, depid, level1
FROM rek_topdown;






-- 6.Sportliche Aufgabe!!
-- Zeigen Sie die gesamte Managementhierarchie ohne Indianer topdown mit 
-- Mitarbeiterkennung, Managerkennung, Nachnamen, Ebene an 
-- und zusätzlich je Manager die Gesamtanzahl ihm unterstellter Mitarbeiter
-- (d.h. akkumuliert: Steven King hat bei 107 Mitarbeitern 106 unter sich)

-- Idee: Berechne je Mitarbeiter die Hierarchie mit Ermittlung, 
-- wer auf jeder Ebene tiefer unterstellt ist (cnt_employees = 1).
-- Anschließend wird aggregiert.

WITH
  emp_count (eid, emp_last, mgr_id, mgrLevel, salary, cnt_employees) AS
  (
    SELECT employee_id, last_name, manager_id, 0 mgrLevel, salary
	       , 0 cnt_employees
    FROM employees
  UNION ALL
    SELECT e.employee_id, e.last_name, e.manager_id,
           r.mgrLevel+1 mgrLevel, e.salary, 1 cnt_employees
    FROM emp_count r, employees e
    WHERE e.employee_id = r.mgr_id
  )
SELECT emp_last, eid, mgr_id, salary
       , sum(cnt_employees)
      , max(mgrLevel) mgrLevel
FROM emp_count
GROUP BY emp_last, eid, mgr_id, salary
HAVING max(mgrLevel) > 0
ORDER BY mgr_id , emp_last;


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
