/* Unterabfragen 2 */

/* Aufgabe 1 - Listen Sie Nachname, Abteilungsnummer und Gehalt eines jeden 
Mitarbeiter auf, dessen Abteilung und Gehaltswert mit dem Gehalt und zugleich 
der Abteilungsnummer eines Mitarbeiters übereinstimmt, der eine Provision 
(commission_pct) erhält */

-- leider kennt SQLServer keine Tupelvergleiche (ANSI schon):
/* 
  SELECT last_name, department_id, salary
  FROM employees
  WHERE (salary, department_id) IN 
      (SELECT salary, department_id FROM employees
           WHERE commission_pct IS NOT NULL) ;
*/
-- Um die Logik zu testen, kommt hier eine Ergänzung der Datensätze ins Spiel
BEGIN TRANSACTION;

INSERT INTO employees (employee_id, last_name, email, hire_date, job_id, salary, department_id, commission_pct)
     VALUES (1, 'mustermann1', 'musteremail1', getDate(), 'IT_PROG', 11000, 50, 0.1),
	        (2, 'mustermann2', 'musteremail2', getDate(), 'IT_PROG', 500, 80, 0.1);

-- das sollte korrekt sein!!
-- durch den JOIN entstehen Duplikate
SELECT DISTINCT e.employee_id, e.last_name, e.department_id, e.salary
  FROM employees e JOIN  
      (SELECT employee_id, last_name , salary, department_id FROM employees
		WHERE commission_pct IS NOT NULL) s
   ON e.department_id = s.department_id AND e.salary = s.salary
   WHERE e.employee_id != s.employee_id
   ORDER BY e.last_name;

-- das ist leider nicht korrekt!!
SELECT last_name, department_id, salary
  FROM employees
  WHERE salary IN (SELECT salary FROM employees
						WHERE commission_pct IS NOT NULL)
		AND
		department_id IN (SELECT department_id FROM employees
						WHERE commission_pct IS NOT NULL)
	order by last_name;


-- das dürfte auch korrekt sein
SELECT Distinct e1.last_name, e1.department_id, e1.salary
FROM employees e1
Where department_id In (SELECT department_id
        From employees e2
        where e1.department_id = e2.department_id and
        e1.salary = e2.salary and
        e2.commission_pct > 0 and 
		e1.employee_id != e2.employee_id)
Order by last_name;

ROLLBACK; 

           
/* Aufgabe 2 - Listen Sie Nachname, Einstellungsdatum und Gehalt eines jeden 
Mitarbeiter an, der das  gleiche Gehalt und die gleiche Provision wie der 
Mitarbeiter 'Kochhar' erhält. Kochhar soll nicht im Ergebnis enthalten sein */

SELECT last_name, hire_date, salary
  FROM employees
  WHERE salary IN (SELECT salary FROM employees
            WHERE last_name = 'Kochhar')
		AND 
		COALESCE(commission_pct, 0) IN (SELECT COALESCE(commission_pct, 0) FROM employees
            WHERE last_name = 'Kochhar')
        AND last_name != 'Kochhar';
                 
-- Was ist, wenn es mehrere Kochhars gibt?     
        
/* Aufgabe 3 - Zeigen Sie die Mitarbeiter an, deren Gehalt höher als das Gehalt 
aller Sales Manager ist (job_id = 'SA_MAN'). Sortieren Sie die Ergebnisse
vom höchsten zum niedrigsten Gehalt. */

SELECT last_name, job_id, salary FROM employees
  WHERE salary > ALL (SELECT salary FROM employees
                        WHERE job_id = 'SA_MAN')
  ORDER BY  salary desc;
  
-- oder alternativ mit Max arbeiten:

SELECT last_name, job_id, salary FROM employees
  WHERE salary > (SELECT max(salary) FROM employees
                        WHERE job_id = 'SA_MAN')
  ORDER BY  salary desc;


/* Aufgabe 4 - Suchen Sie alle Angestellten und zeigen deren Namen an, die keine Vorgesetzten sind. 
Verwenden Sie dabei möglichst den EXISTS-Operator. 
Können Sie die Aufgabe auch mit dem IN-Operator lösen? */

SELECT o.first_name, o.last_name FROM employees o
  WHERE NOT EXISTS ( SELECT 'EgalWas' FROM employees
                       WHERE manager_id = o.employee_id);
                       
-- alternativ via IN-Operator

SELECT first_name, last_name FROM employees
   WHERE employee_id NOT IN ( SELECT DISTINCT manager_id FROM employees 
                                WHERE manager_id IS NOT NULL
                                -- nicht vergessen, auf NOT NULL zu prüfen!
                                );
                          

/* Aufgabe 5 - Zeigen Sie je Mitarbeiter in einer Zeile den Nachnamen, das Gehalt 
sowie die Anzahl der Mitarbeiter an, die mehr verdienen. */

SELECT last_name, salary, (SELECT count(*) FROM employees
                    WHERE e.salary < salary) as higher
  FROM employees e
  ORDER BY higher; 

-- oder mit Cross Apply
SELECT e.last_name, e.salary, others.c as higher
  FROM employees e
    CROSS APPLY  
	  (SELECT count(*) c FROM employees
                    WHERE e.salary < salary) others
  ORDER BY higher; 

 -- oder
SELECT last_name, salary, count(oid) as higher FROM 
    (SELECT e.employee_id, e.last_name , e.salary, others.employee_id oid
	  FROM employees e
			LEFT OUTER JOIN 
		   employees others
			ON e.salary < others.salary ) base
  GROUP BY employee_id, last_name, salary
  ORDER BY higher;

  -- oder mit OVER-Klausel
SELECT DISTINCT e.last_name , e.salary, count(others.employee_id) over (Partition By e.employee_id) higher
	  FROM employees e
			LEFT OUTER JOIN 
		   employees others
			ON e.salary < others.salary 
  ORDER BY higher; 

-
	     


/* Aufgabe 6  Erstellen Sie eine Abfrage, um die Angestelltennummer und den Nachnamen 
der Mitarbeiter anzuzeigen, die in Kalifornien (state_province = 'California') arbeiten. 
Verwenden Sie skalare Unterabfragen */

SELECT employee_id, last_name FROM employees e
  WHERE ( (SELECT location_id FROM departments d 
              WHERE e.department_id = d.department_id)
           IN (SELECT location_id FROM locations l
                  WHERE state_province = 'California'))
  ORDER BY last_name;
                  
-- alternativ wäre die Aufgabe prinzipiell auch via JOIN lösbar:
SELECT e.employee_id, e.last_name 
    FROM employees e JOIN departments d
                     ON e.department_id = d.department_id
                     JOIN locations l
                     ON d.location_id = l.location_id
        WHERE l.state_province = 'California'
    ORDER BY last_name;
                  
                  
/* Aufgabe 7 Erstellen Sie eine Abfrage, um die Jobkennungen der Jobs anzuzeigen,
deren Maximalgehalt 50% des Maximalgehalts des gesamten Unternehmens übersteigt.
Verwenden Sie die WITH-Klausel */

WITH max_sal_calc AS
    ( SELECT job_title, MAX(salary) AS job_max
			FROM employees 
				JOIN jobs ON employees.job_id = jobs.job_id
	  GROUP BY job_title)
SELECT job_title, job_max FROM max_sal_calc
  WHERE job_max > ( SELECT MAX(job_max) / 2
                      FROM max_sal_calc)
  ORDER BY job_max DESC; 


-- Variante ohne WITH-Klausel
SELECT job_title, job_max FROM 
       ( SELECT job_title, MAX(salary) AS job_max
			FROM employees 
				JOIN jobs ON employees.job_id = jobs.job_id
			GROUP BY job_title) max_sal_calc 
     WHERE job_max > ( SELECT MAX(max_sal_calc.job_max) / 2
                      FROM 
					  ( SELECT job_title, MAX(salary) AS job_max
							FROM employees 
								JOIN jobs ON employees.job_id = jobs.job_id
							GROUP BY job_title) max_sal_calc 
					  ) 
  ORDER BY job_max DESC; 
  

/* Aufgabe 8 Erstellen Sie eine Abfrage, um die Namen der Abteilungen anzuzeigen,
deren Gesamtlohnkosten ein Achtel (1/8) der Gesamtlohnkosten des Unternehmens 
übersteigen. Verwenden Sie die WITH-Klausel. */

WITH SUMMARY AS
  ( SELECT d.department_name, sum(e.salary) AS dept_total
     FROM employees e JOIN departments d
          ON e.department_id = d.department_id
     GROUP BY department_name)
SELECT department_name, dept_total
  FROM SUMMARY
  WHERE dept_total > (SELECT sum(dept_total) * 1/8 FROM SUMMARY)
  ORDER BY dept_total desc;
