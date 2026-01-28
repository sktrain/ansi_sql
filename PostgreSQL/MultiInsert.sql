
CREATE TABLE e1 AS SELECT * FROM employees WHERE FALSE;
CREATE TABLE e2 AS SELECT * FROM employees WHERE FALSE;

WITH 
    selectrows AS ( SELECT * FROM employees WHERE last_name = 'King')
    , ins1 AS (INSERT INTO e1 SELECT * FROM selectrows WHERE first_name = 'Steven')
INSERT INTO e2
SELECT * FROM selectrows;


