-- Übung: Verwendung von Gruppenfunktionen  -  Lösungen

-- 1.	Zeigen Sie das h�chste Gehalt, das niedrigste Gehalt, die Summe aller 
-- Geh�lter und das Durchschnittsgehalt f�r alle Mitarbeiter an. 
-- Runden Sie das Ergebnis auf die nächste ganze Zahl.

SELECT	ROUND(MAX(salary), 0)  	"Maximum",
			ROUND(MIN(salary), 0)   	"Minimum",
			ROUND(SUM(salary), 0)   	"Summe",
			ROUND(AVG(salary), 0)		"Durchschnitt"
FROM	employees;


-- 2.	Ver�ndern Sie die vorherige Abfrage so, dass die Werte je Jobkennung 
-- berechnet und angezeigt werden. 

SELECT 	job_id, 
			ROUND (MAX(salary), 0)  	"Maximum",
			ROUND (MIN(salary), 0)   "Minimum",
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
-- Buchstaben "n" endet.

SELECT   count(*) 
	FROM   employees
  WHERE  last_name  LIKE  '%n' ;

-- oder
SELECT   count(*) 
	FROM       employees
  WHERE    right(last_name, 1) = 'n' ;
  
-- oder ANSI substring (ziemlich archaische Schreibe)
SELECT   count(*) 
	FROM       employees
  WHERE    substring(last_name FROM length(last_name)) = 'n' ;
  



-- 8. Zeigen Sie je Kalenderjahr an, wieviele Angestellte jeweils eingestellt 
-- wurden.  
SELECT CAST(YEAR(hire_date) AS CHAR) AS "YEAR", 
        count(*) as "COUNT" FROM employees
GROUP BY YEAR(hire_date)
ORDER BY YEAR(hire_date);

    
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
  
  
-- 10. Zeigen Sie für alle Mitarbeiter, deren Managerkennung kleiner 130 ist, 
-- Folgendes an:
-- Managerkennung,  Job-Kennung und Gesamtgehalt für jede Jobkennung, 
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
  GROUP BY manager_id, job_id WITH ROLLUP
  ;
  

  

