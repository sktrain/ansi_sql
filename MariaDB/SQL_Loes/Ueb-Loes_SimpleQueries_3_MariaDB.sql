-- Übung: Verwendung von Funktionen  -  Lösungen 

-- 1.	Zeigen Sie f�r jeden Mitarbeiter die Mitarbeiternummer, den Nachnamen, 
-- das Gehalt und das Gehalt mit 15% Zuwachs, diesen Wert als Ganzzahl und mit 
-- der Überschrift "New Salary".

SELECT 	employee_id, last_name, salary,
		Round(salary * 1.15, 0) "New Salary"
FROM	employees;


-- 2.	Verandern Sie die vorhergehende Abfrage so, dass eine zusätzliche Spalte 
-- mit dem Bezeichner "Increase" angezeigt wird, die das alte vom neuen 
-- Gehalt abzieht.

SELECT 	employee_id, last_name, salary,
			ROUND(salary * 1.15, 0) "New Salary",
			ROUND(salary * 1.15, 0) - salary "Increase"
	FROM	employees;
  
  
-- 3.	Schreiben Sie eine Abfrage, die den Nachnamen des Mitarbeiters, beginnend
-- mit einem Großbuchstaben und den Rest in Kleinschreibung, und die L�nge des 
-- Namens anzeigt, für die Mitarbeiter, deren Nachname mit J, A oder M beginnt. 
-- Geben Sie den Spalten entsprechende Bezeichner und sortieren Sie die Ausgabe
-- nach den Namen.

SELECT CONCAT(UPPER(LEFT(last_name,1)), LOWER(RIGHT(last_name,LENGTH(last_name)-1))) AS  "Name",
		LENGTH(last_name)  AS  "Length"
FROM	employees
WHERE	last_name LIKE 'J%'
			OR	last_name LIKE 'M%'
			OR	last_name LIKE 'A%'
	ORDER BY	last_name;

-- oder

SELECT CONCAT(UPPER(LEFT(last_name,1)), LOWER(RIGHT(last_name,LENGTH(last_name)-1))) AS  "Name",
		LENGTH(last_name)  AS  "Length"
FROM	employees
WHERE	SUBSTR(last_name,1,1) in ('J', 'A', 'M')
ORDER BY	last_name;

 
-- 4.	Zeigen Sie für alle Mitarbeiter den Nachnamen und die Anzahl der 
-- Kalendermonate zwischen dem aktuellen Datum und dem Einstellungsdatum, 
-- sortiert nach der Anzahl Monate. 
-- Zwischen dem 30.01.2005 und dem 01.02.2005 sollte schon ein Monat liegen,
-- d.h es geht um Kalendermonate !!

SELECT	last_name 
  , CURRENT_DATE
  , hire_date
  , CEILING(MONTHS_BETWEEN(CURRENT_DATE, hire_date)) as "Anzahl Monate"  
FROM	employees
ORDER BY 4;

-- nur zum Test
SELECT CEILING(MONTHS_BETWEEN
       (DATE '1995-02-02',
        DATE '1995-01-31' 
       ));


-- 5.	Schreiben Sie eine Abfrage um den Nachnamen und das Gehalt aller 
-- Mitarbeiter anzuzeigen. Formatieren Sie die Ausgabe des Gehalts auf 15 
-- Stellen, links aufgef�llt mit "$", unter dem Bezeichner "Salary".

SELECT	last_name, LPAD(salary, 15, '$') "Salary"
FROM	employees;  -- LPAD erwartet als 1. Param einen String!

-- oder 
SELECT	last_name, LPAD(CAST(salary AS CHAR) , 15, '$') "Salary"
FROM	employees;


-- 6.	Schreiben Sie eine Abfrage, die den Nachnamen und die Managerkennung der
-- Mitarbeiter anzeigt. Falls der Mitarbeiter keinen Manager hat, soll 
-- "No Manager" ausgegeben werden.

SELECT 	last_name,
			COALESCE(manager_id, 'No Manager') "Manager"  -- impliziter Cast!
FROM	 employees;

 
-- 7.	Schreiben Sie eine Abfrage, um eine Einstufung der Mitarbeiter auf Basis 
-- ihrer Jobkennung in folgender Form anzuzeigen:
--
-- JOB			GRADE
-- AD_PRES		A
-- ST_MAN		B
-- IT_PROG		C
-- SA_REP		D
-- ST_CLERK		E
-- None of the above	0

SELECT job_id, CASE job_id
		WHEN 'ST_CLERK' THEN 'E'
		WHEN 'SA_REP' THEN 'D'
		WHEN 'lT_PROG' THEN 'C'
		WHEN 'ST_MAN' THEN 'B'
		WHEN 'AD_PRES' THEN 'A'
		ELSE '0' END AS GRADE 
FROM employees;



-- 8. Schreiben Sie eine Abfrage, um eine Einstufung der Abteilungen auf Basis 
-- ihrer Abteilungskennung in folgender Form anzuzeigen:
-- "Department_Name			Level". 
-- Dabei sollen Abteilungen mit einer Kennung < 100 den Level "< 100", 
-- Abteilungen mit einer Kennung zwischen 100 und 200 den Level "100 - 200" 
-- und Abteilungen mit einer Kennung > 200 den Level "> 200" erhalten.

SELECT	department_name, 
		CASE 
		WHEN department_id < 100 THEN '< 100'
		WHEN department_id BETWEEN 100 AND 200 THEN '100 - 200'
		WHEN department_id > 200 THEN '> 200'
		END AS "Level"		
	FROM departments;
 
