/*
SELECT *
    FROM employees 
    JOIN LATERAL 
        (SELECT * FROM departments
                  WHERE departments.department_id = employees.department_id
        ) derived_table
    ON 1=1;
*/ 

SELECT *
    FROM employees 
    CROSS APPLY 
        (SELECT * FROM departments
                  WHERE departments.department_id = employees.department_id
        ) derived_table;
    

SELECT *
    FROM employees 
    OUTER APPLY
        (SELECT * FROM departments
                  WHERE departments.department_id = employees.department_id
        ) derived_table
   ;
   

SELECT * 
    FROM departments
    CROSS APPLY
         (SELECT TOP(1) employee_id, last_name, salary FROM employees
             WHERE departments.department_id = employees.department_id
             ORDER BY salary
         ) derived_table;         