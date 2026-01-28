-- Übungen zu Indizes

-- a) Um die Performanceunterschiede durch den Einsatz eines Index besser 
-- messen zu können, führen Sie bitte die folgenden Schritte durch:
CREATE TABLE big_emp AS SELECT * FROM employees;

-- ca. 11-mal durchführen ergibt ca. 200.000 Zeilen
INSERT INTO big_emp SELECT * FROM big_emp; 

-- SELECT Count(*) FROM big_emp;

-- neue Spalte anhängen für Primary key
ALTER TABLE big_emp ADD nr int;

-- eindeutige Spaltenwert vergeben
CREATE TEMP SEQUENCE temp_seq;
UPDATE big_emp SET nr= nextval('temp_seq'); 




EXPLAIN ANALYZE
SELECT * FROM big_emp WHERE nr=8000;
-- Merken Sie sich bitte die Laufzeit.



-- Vergeben Sie nun einen Unique-Index auf die Spalte nr.
CREATE UNIQUE INDEX big_emp_nr_ind ON big_emp (nr);

EXPLAIN ANALYZE
SELECT * FROM big_emp WHERE nr=8000;
-- Vergleichen Sie die Laufzeit und den Ausführungsplan mit oben.

-- b) Warum werden die Abfragen bei der zweiten Ausführung meist schneller?


-- Löschen Sie die Tabelle BIG_EMP und die Sequenz wieder.
DROP TABLE big_emp;
DROP SEQUENCE temp_seq; 
