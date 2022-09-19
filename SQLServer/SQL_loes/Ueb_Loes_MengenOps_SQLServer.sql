-- �bung 7: Mengenoperatoren  -  L�sungen

-- 1.	Listen Sie die Abteilungskennungen der Abteilungen, die keine Mitarbeiter
-- mit der Jobkennung "ST_CLERK" haben.

SELECT department_id FROM departments
EXCEPT
SELECT department_id FROM employees WHERE job_id = 'ST_CLERK' ;



-- 2. Erweitern Sie die Abfrage von Aufgabe 1, so dass auch der Abteilungsname angezeigt wird.

SELECT department_id, department_name FROM departments
EXCEPT
SELECT e.department_id, d.department_name FROM employees e JOIN departments d
											ON e.department_id = d.department_id
										WHERE job_id = 'ST_CLERK' ;
										
-- oder

SELECT d.department_id, d.department_name
FROM departments d JOIN	(	SELECT department_id FROM departments
							EXCEPT
							SELECT department_id FROM employees WHERE job_id = 'ST_CLERK') e
					ON d.department_id = e.department_id ;
					
-- oder  
SELECT department_id, department_name
FROM departments where department_id in
	(SELECT department_id FROM departments
		EXCEPT
	 SELECT department_id FROM employees WHERE job_id = 'ST_CLERK' );


-- 3. Zeigen Sie die Mitarbeiterkennung und aktuelle Jobkennung der Mitarbeiter an,
-- die bereits zwischenzeitlich in einer anderen Position gearbeitet haben, jetzt aber wieder 
-- in ihre urspr�ngliche Position wie zum Zeitpunkt der Einstellung zur�ckgekehrt sind.	

SELECT	employee_id, job_id	FROM employees	
INTERSECT 
SELECT	employee_id, job_id	FROM job_history;	


-- 4. Zeigen Sie die Nachnamen und Abteilungskennungen aller Mitarbeiter an, 
-- unabh�ngig davon, ob sie zu einer Abteilung geh�ren,
-- zusammen mit den Abteilungsnamen und Abteilungskennungen, unabh�ngig davon,
-- ob Mitarbeiter zu der Abteilung geh�ren. 
-- Die Ausgabe soll dreispaltig sein: Nachname, Abteilungskennung, Abteilungsname 
-- und sortiert nach der Abteilungskennung

SELECT	last_name, department_id, ''
	FROM	employees	
UNION
SELECT	'', department_id, department_name
	FROM departments
ORDER BY department_id;  -- ORDER BY nur am Ende m�glich
	
-- alternativ per OUTER JOIN mit Ausgabe der leeren Zeichenkette anstatt der NULL

SELECT ISNULL(e.last_name, '') , d.department_id, ISNULL(d.department_name, '')
FROM employees e FULL OUTER JOIN departments d
	ON e.department_id = d.department_id
ORDER BY d.department_id;
	

-- 5. �ndern Sie die Abfrage aus Aufgabe 4 so, dass nur die Mitarbeiter angezeigt werden, 
-- die keiner Abteilung zugeordnet sind, und nur die Abteilungen, die keine Mitarbeiter haben.

SELECT	last_name, department_id, ''
	FROM	employees	WHERE	department_id IS NULL		
UNION
SELECT	'', department_id, department_name
	FROM departments	WHERE   department_id not in ( SELECT department_id
														FROM employees
														WHERE department_id IS NOT NULL )
ORDER BY department_id; 

-- oder mal 2-spaltig ohne NULL f�r die Abteilungskennung

SELECT	last_name, 'keine Abteilung' as "Abteilung"
	FROM	employees	WHERE	department_id IS NULL		
UNION
SELECT	department_name, CONVERT(varchar, department_id)
	FROM departments	WHERE   department_id not in ( SELECT department_id
														FROM employees
														WHERE department_id IS NOT NULL )
ORDER BY "Abteilung"; 


-- 6. Erstellen Sie mit Hilfe von Mengenoperatoren eine Jobliste f�r die Abteilungen 
-- 10, 50, 20 in genau dieser Sortierreihenfolge. Zeigen Sie die Jobkennung und die 
-- Abteilungskennung an (und eventuell zus�tzlich notwendige Spalten).

SELECT job_id, department_id, 0 as dummy
	FROM employees	WHERE department_id = 10
UNION
SELECT job_id, department_id, 1 as dummy
	FROM employees	WHERE department_id = 50
UNION
SELECT job_id, department_id, 2 as dummy
	FROM employees	WHERE department_id = 20
ORDER BY dummy;


 				