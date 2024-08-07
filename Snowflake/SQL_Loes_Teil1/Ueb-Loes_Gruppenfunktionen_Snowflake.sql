-- �bung: Verwendung von Gruppenfunktionen  -  L�sungen

-- 1.	Zeigen Sie das h�chste Gehalt, das niedrigste Gehalt, die Summe aller 
-- Geh�lter und das Durchschnittsgehalt f�r alle Mitarbeiter an. 
-- Runden Sie das Ergebnis auf die n�chste ganze Zahl.

SELECT	ROUND (MAX (salary), 0)  	"Maximum",
			ROUND (MIN (salary), 0)   	"Minimum",
			ROUND (SUM(salary), 0)   	"Summe",
			ROUND (AVG(salary), 0)		"Durchschnitt"
FROM	employees;


-- 2.	Ver�ndern Sie die vorherige Abfrage so, dass die Werte je Jobkennung 
-- berechnet und angezeigt werden. 

SELECT 	job_id, 
			ROUND (MAX (salary), 0)  	"Maximum",
			ROUND (MIN (salary), 0)   "Minimum",
			ROUND (SUM(salary), 0)   	"Summe",
			ROUND (AVG(salary), 0)		"Durchschnitt"
FROM	employees
GROUP BY 	job_id;


-- 3.	Zeigen Sie die Jobkennungen und die Anzahl der Mitarbeiter mit 
-- diesem Job an.

SELECT  job_id,   COUNT(*)
FROM	employees
GROUP  BY  job_id;


-- 4.	Zeigen Sie die Differenz zwischen dem niedrigsten und h�chsten Gehalt 
-- je Abteilung an. Nennen Sie die Spalte �Differenz�.

SELECT	department_id,   MAX(salary) - MIN(salary)   "Differenz"
FROM	employees
GROUP  BY  department_id;


-- 5.	Bestimmen Sie die Anzahl der Manager (ohne diese aufzulisten).

SELECT	COUNT( DISTINCT manager_id )   "Anzahl Manager"
FROM	employees;
 

-- 6.	Zeigen Sie je Managerkennung das Gehalt des unterstellten Angestellten 
-- mit dem niedrigsten Gehalt an. 
-- Schlie�en Sie alle Angestellten aus, deren Manager nicht bekannt ist. 
-- Schlie�en Sie alle Gruppen aus, deren Mindestgehalt 6000 oder weniger 
-- betr�gt.
-- Sortieren Sie die Ausgabe in absteigender Reihenfolge nach dem Gehalt.
SELECT manager_id, MIN(salary)
	FROM employees
	WHERE manager_id IS NOT NULL
	GROUP BY manager_id
	HAVING MIN(salary) > 6000
	ORDER BY MIN(salary) DESC;


-- oder mit Anzeige des Managernamen (bedingt Self-Join)
SELECT  i.manager_id, c.last_name, MIN(i.salary)
	FROM employees i JOIN employees c
      ON i.manager_id = c.employee_id
	WHERE i.manager_id IS NOT NULL
	GROUP BY i.manager_id, c.last_name
	HAVING MIN(i.salary) > 6000
	ORDER BY MIN(i.salary) DESC; 
  

-- 7.	Zeigen Sie die Anzahl der Mitarbeiter, deren Nachname mit dem 
-- Buchstaben �n� endet.

SELECT   count(*) 
	FROM   employees
  WHERE  last_name  LIKE  '%n' ;

-- oder
SELECT   count(*) 
	FROM       employees
  WHERE    right(last_name, 1) = 'n' ;
  




-- 8. Zeigen Sie je Kalenderjahr an, wieviele Angestellte jeweils eingestellt 
-- wurden.  
SELECT EXTRACT(YEAR FROM hire_date) AS "YEAR", 
        count(*) as "COUNT" FROM employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY "YEAR";

    
-- 9. Schreiben Sie eine Abfrage, um eine Einstufung der Abteilungen auf Basis 
-- der Mitarbeiteranzahl in folgender Form anzuzeigen:
-- "Department_ID			Size". 
-- Dabei sollen Abteilungen mit weniger als 5 Mitarbeitern die Size "Little",
-- Abteilungen mit einer Mitarbeiterzahl zwischen 5 und 9 die Size "Medium"
-- Abteilungen mit einer Mitarbeiterzahl ab 10 die Size "Big" erhalten.

SELECT	department_id, 
		CASE
			WHEN department_id IS NULL THEN 'no department'
			WHEN count(department_id) < 5 THEN 'Little'
			WHEN count(department_id) BETWEEN 5 AND 9 THEN 'Medium'
			WHEN count(department_id) > 9 THEN 'Big'
		END AS "Size"		
	FROM employees
	GROUP BY department_id; 
  
  
-- 10. Zeigen Sie f�r alle Mitarbeiter, deren Managerkennung kleiner 130 ist, 
-- Folgendes an:
-- Managerkennung,  Job-Kennung und Gesamtgehalt f�r jede Jobkennung, 
-- sortiert nach der Managerkennung.

SELECT manager_id, job_id, sum(salary) "Gehaltssumme"
  FROM employees
  WHERE manager_id < 130
  GROUP BY manager_id, job_id
  ORDER BY manager_id;




  
-- 11. Erweitern Sie Aufgabe 10, so dass zus�tzlich angezeigt wird:
-- Gesamtgehalt der Mitarbeiter unter dem jeweiligen Manager, 
-- Gesamtgehalt aller Mitarbeiter unter diesen Managern.

SELECT manager_id, job_id, sum(salary)  "Gehaltssumme"
  FROM employees
  WHERE manager_id < 130
  GROUP BY ROLLUP (manager_id, job_id)
  ORDER BY manager_id;
  

  

-- 12. Erweitern Sie Aufgabe 10 um eine Anzeige, die deutlich macht, 
-- ob die Nullwerte in den Spalten aus der Rollup-Auswertung resultieren 
-- oder auf Basis gespeicherter Nullwerte aus der Tabelle zustande kommen.

SELECT manager_id, job_id, 
       sum(salary) "Gehaltssumme", 
       grouping(manager_id) "Null-Manager",
       grouping(job_id)  "Null-Jobid"
  FROM employees
  WHERE manager_id < 130
  GROUP BY ROLLUP (manager_id, job_id)
  ORDER BY manager_id;
  
-- oder erweitert: via Case-Anweisung sch�nere Ausgabe statt 0 oder 1

SELECT manager_id, job_id, 
       sum(salary) "Gehaltssumme", 
       CASE grouping(manager_id) WHEN 1 THEN 'Aggregiert'
                                 ELSE ' '  
          -- leere Zeichkette wird eventuell vom Tool als "null" ausgegeben
                                 END  AS "Sum_je_Man",
       CASE grouping(job_id) WHEN 1 THEN 'Aggregiert'
                                 ELSE ' '
                                 END  AS "Sum_je_Job"
  FROM employees
  WHERE manager_id < 130
  GROUP BY ROLLUP (manager_id, job_id)
  ORDER BY manager_id ;
  
-- oder, ebenfalls via Case, aber in den Gruppierungsspalten vern�nftig 
-- angezeigt

SELECT CASE WHEN manager_id is null and grouping(manager_id) = 1
              THEN 'Gesamtsumme' 
            WHEN manager_id is null and grouping(manager_id) = 0
              THEN 'Nullgruppe Manager_ID'
            ELSE to_char(manager_id, '999999') END AS MANAGER_ID,
       CASE WHEN job_id is null and grouping(job_id) = 1 
                                and grouping(manager_id) = 1
              THEN ''
            WHEN job_id is null and grouping(job_id) = 1 
              THEN 'Summe ' || manager_id  -- n�chsth�here Gruppierung anzeigen
            WHEN job_id is null and grouping(job_id) = 0 
              THEN 'Null-Gruppe JOB_ID'
            ELSE job_id
       END AS JOB_ID,
       sum(salary) "Gehaltssumme"
       -- , case grouping(manager_id) WHEN 1 THEN 'Aggregiert'
       --                          ELSE ' '             
       --                         END  AS "Sum_je_Man",
       -- case grouping(job_id) WHEN 1 THEN 'Aggregiert'
       --                          ELSE ' '
       --                          END  AS "Sum_je_Job"
  FROM employees
  WHERE manager_id < 130
  GROUP BY ROLLUP (manager_id, job_id)
  ORDER BY manager_id desc, job_id;

  
  
  
  
-- 13. Erweitern Sie die Abfrage aus Aufgabe 12, so dass zus�tzlich angezeigt 
-- wird: Gesamtgehalt je Jobkennung unabh�ngig vom Manager.

SELECT  manager_id
        , job_id
        , sum(salary) "Gehaltssumme"
        , CASE grouping(manager_id) 
            WHEN 1 THEN 'Aggregiert'
                ELSE ' '     
          END  AS "Sum_je_Man"
        , CASE grouping(job_id) 
            WHEN 1 THEN 'Aggregiert'
                ELSE ' '
          END  AS "Sum_je_Job"
  FROM employees
  WHERE manager_id < 130
  GROUP BY CUBE (manager_id, job_id)
  ORDER BY manager_id;


-- 14. Modifizieren Sie die Abfrage aus Aufgabe 11, so dass nur folgende 
-- Gruppierungen angezeigt werden:
-- (Abteilungskennung, Managerkennung, Jobkennung),
-- (Abteilungskennung, Jobkennung),
-- (Managerkennung, Jobkennung)

SELECT department_id, manager_id, job_id, sum(salary)  "Gehaltssumme"
  FROM employees
  WHERE manager_id < 130
  GROUP BY 
  GROUPING SETS ( (department_id, manager_id, job_id),
                  (department_id, job_id),
                  (manager_id, job_id) )
  ORDER BY department_id, manager_id;
  
  
  
-- 15. Erstellen Sie eine Abfrage, um folgende Angaben f�r alle Abteilungen 
-- anzuzeigen, deren Abteilungsnummer gr��er als 80 ist:
--  - Gesamtgehalt f�r jeden Job in der Abteilung
--  - Das Gesamtgehalt
--  - Das Gesamtgehalt f�r die St�dte, in denen sich Abteilungen befinden
--  - Das Geamtgehalt f�r jeden Job, unabh�ngig von der Abteilung
--  - Das Gesamtgehalt f�r jede Abteilung, unabh�ngig von der Stadt
--  - Das Gesamtgehalt f�r die Abteilungen, unabh�ngig von Job-Bezeichnung
--    und Stadt

SELECT l.city, d.department_name, e.job_id, sum(e.salary) sum_salary
  FROM locations l 
       JOIN departments d ON l.location_id = d.location_id
       JOIN employees e ON e.department_id = d.department_id
  WHERE e.department_id > 80
  GROUP BY CUBE ( l.city, d.department_name, e.job_id)
  ORDER BY l.city, d.department_name, e.job_id;
  
-- oder mit Verwendung von GROUPING 
SELECT l.city, d.department_name, e.job_id, sum(e.salary) sum_salary
       ,GROUPING(l.city) gcity
       ,GROUPING(d.department_name) gdep
       ,GROUPING(e.job_id) gjob
       ,GROUPING(l.city, d.department_name, e.job_id)
  FROM locations l 
       JOIN departments d ON l.location_id = d.location_id
       JOIN employees e ON e.department_id = d.department_id
  WHERE e.department_id > 80
  GROUP BY CUBE ( l.city, d.department_name, e.job_id);
  

  
-- 16  Erstellen Sie eine Abfrage, um folgende Gruppierungen anzuzeigen:
--  - Abteilungsnummer, Jobkennung
--  - Jobkennung, Managerkennung
--  wobei die Ausgabe das Maximal- und das Minimalgehalt nach Abteilung, 
--  T�tigkeit und Manager enthalten soll.
SELECT department_id, job_id, manager_id, MAX(salary), MIN(salary)
  FROM employees 
  GROUP BY GROUPING SETS ((department_id, job_id), (job_id, manager_id));
  
-- mit Anzeige des Namens der Abteilung und des Vorgesetzten (Manager)
SELECT d.department_name, e.job_id, e.manager_id, 
       MAX(salary) max_salary, 
       MIN(salary) min_salary
  FROM employees e 
       LEFT OUTER JOIN departments d ON e.department_id = d.department_id
  GROUP BY GROUPING SETS ((e.department_id, d.department_name, e.job_id), 
                          (e.job_id, e.manager_id));
  

