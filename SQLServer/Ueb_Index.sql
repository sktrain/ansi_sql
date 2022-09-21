-- �bungen zu Indizes

-- a) Um die Performanceunterschiede durch den Einsatz eines Index besser 
-- messen zu k�nnen, f�hren Sie bitte die folgenden Schritte durch:
SELECT * INTO big_emp FROM employees;

-- ca. 8-mal durchf�hren ergibt ca. 50.000 Zeilen
INSERT INTO big_emp SELECT * FROM big_emp; 

-- explizter Commit wird im AutoCommit-Modus nicht ben�tigt
-- COMMIT

-- neue Spalte anh�ngen f�r Primary key
ALTER TABLE big_emp ADD nr int;

CREATE SEQUENCE myseq
AS int
START WITH 1;


-- eindeutige Spaltenwert vergeben
UPDATE big_emp SET nr = NEXT VALUE FOR myseq; 


-- zur besseren Messung 
-- Switch on statistics time 
SET STATISTICS TIME ON; 
-- bei Interesse an der IO-Last
SET STATISTICS IO ON;
 
SELECT * FROM big_emp WHERE nr=50000;
-- Merken Sie sich bitte die Laufzeit.



-- Vergeben Sie nun einen Unique-Index auf die Spalte nr.
CREATE UNIQUE INDEX big_emp_nr_ind ON big_emp (nr);

SELECT * FROM big_emp WHERE nr=50000;
-- Vergleichen Sie die Laufzeit und den Ausf�hrungsplan mit oben.


--Aufr�umen
SET STATISTICS TIME OFF; 
SET STATISTICS IO OFF;
DROP TABLE big_emp;
DROP SEQUENCE myseq;
