/* Hierarchische Queries mit der rekursiven With-Klausel 
    - ANSI -Standard
    - Oracle, SQL Server, DB2:  WITH
    - PostgreSQL, MySQL:        WITH RECURSIVE
*/

-- top-down
WITH RECURSIVE rek_topdown( eid, lname, mgrid ) AS  --Spaltenaliase sind Pflicht
    (   SELECT employee_id, last_name, manager_id  -- Anker
        FROM employees WHERE manager_id is null
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id   --Rekusion via Join
        FROM employees e, rek_topdown r WHERE e.manager_id = r.eid
    )
SELECT eid, lname, mgrid
FROM rek_topdown;



-- top-down with level (level ist Schlüsselwort bei Oracle -> step)
WITH RECURSIVE rek_topdown( eid, lname, mgrid, step ) AS
    (   SELECT employee_id, last_name, manager_id, 1
        FROM employees WHERE manager_id is null
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id, r.step+1
        FROM employees e JOIN rek_topdown r ON e.manager_id = r.eid
    )
SELECT eid, lname, mgrid, step
FROM rek_topdown;



-- top-down with level and parentname, PostgreSQL needs CAST (see below)
WITH RECURSIVE rek_topdown( eid, lname, mgrid, mgrname, step ) AS
    (   SELECT employee_id, last_name, manager_id, ''::text, 1
        FROM employees WHERE manager_id is null
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id, r.lname, r.step+1
        FROM employees e JOIN rek_topdown r ON e.manager_id = r.eid
    )
SELECT eid, lname, mgrid, mgrname, step
FROM rek_topdown;





-- top-down many trees with level and parentname, PostgreSQL needs CAST (see below)
WITH RECURSIVE rek_topdown( eid, lname, mgrid, mgrname, step ) AS
    (   SELECT employee_id, last_name, manager_id, ''::text, 1
        FROM employees WHERE employee_id = 101 or employee_id = 102
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id, r.lname, r.step+1
        FROM employees e JOIN rek_topdown r ON e.manager_id = r.eid
    )
SELECT eid, lname, mgrid, mgrname, step
FROM rek_topdown
;





-- top-down aufgeruescht, PostgreSQL needs CAST (see below)
WITH RECURSIVE rek_topdown( eid, lname, mgrid, path, step ) AS
    (   SELECT employee_id, last_name, manager_id, last_name::text as path, 1
        FROM employees WHERE manager_id is null
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id
              , r.path || '/' || e.last_name, r.step+1       
        FROM employees e JOIN rek_topdown r ON e.manager_id = r.eid
    )
SELECT eid, lname, mgrid, path, step
FROM rek_topdown;







--bottom-up
WITH RECURSIVE rek_bottomup( eid, lname, mgrid, step ) AS
    (   SELECT employee_id, last_name, manager_id, 0 
        FROM employees WHERE employee_id = 107
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id, r.step - 1
        FROM employees e, rek_bottomup r WHERE e.employee_id = r.mgrid
    )
SELECT eid, lname, mgrid, step
FROM rek_bottomup;





-- top-down many trees with level and parentname, PostgreSQL needs CAST (see below)
WITH RECURSIVE rek_topdown( eid, lname, mgrid, mgrname, step ) AS
    (   SELECT employee_id, last_name, manager_id, ''::text, 1
        FROM employees WHERE manager_id is NULL or manager_id =120
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id, r.lname, r.step+1
        FROM employees e JOIN rek_topdown r ON e.manager_id = r.eid
    )
SELECT eid, lname, mgrid, mgrname, step
FROM rek_topdown
ORDER BY last_name;



-- PostgreSQL: depth-first
WITH RECURSIVE rek_topdown( eid, lname, mgrid, step ) AS
    (   SELECT employee_id, last_name, manager_id, 1
        FROM employees WHERE manager_id is null
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id, r.step+1
        FROM employees e, rek_topdown r WHERE e.manager_id = r.eid
    )
    SEARCH DEPTH FIRST BY lname SET order1
SELECT eid, lname, mgrid, step, order1
FROM rek_topdown
ORDER BY order1
;


-- PostgreSQL: breath-first (macht den selbstverwalteten step obsolet)
WITH RECURSIVE rek_topdown( eid, lname, mgrid ) AS
    (   SELECT employee_id, last_name, manager_id
        FROM employees WHERE manager_id is null
      UNION ALL
        SELECT e.employee_id, e.last_name, e.manager_id
        FROM employees e, rek_topdown r WHERE e.manager_id = r.eid
    )
    SEARCH DEPTH FIRST BY eid SET step
SELECT eid, lname, mgrid, step
FROM rek_topdown
;



-- PostgreSQL: Cyclus-Erkennung
WITH RECURSIVE
  dup_hiredate (eid, emp_last, mgr_id, reportLevel, hire_date, job_id) AS
  (
    SELECT employee_id, last_name, manager_id, 0 reportLevel, hire_date, job_id
    FROM employees
    WHERE manager_id is null
  UNION ALL
    SELECT e.employee_id, e.last_name, e.manager_id,
           r.reportLevel+1 reportLevel, e.hire_date, e.job_id
    FROM dup_hiredate r, employees e
    WHERE r.eid = e.manager_id
  )
  CYCLE emp_last SET is_cycle USING pfad
SELECT * FROM dup_hiredate;
ORDER BY pfad   -- pfad verkörpert gleichzeitig depth-first
;
