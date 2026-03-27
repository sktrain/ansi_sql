-- �bungen/L�sungen zu DML

-- 1. Erzeugen Sie mit Hilfe der folgenden Anweisungen die Tabelle "MY EMPLOYEE", die im Folgenden verwendet wird:

CREATE TABLE MY_EMPLOYEE
  ( id INTEGER NOT NULL, 
    lastname VARCHAR(25),
    firstname VARCHAR(25),
    userid VARCHAR(8),
    salary DECIMAL(9,2));
    
 
    
-- 2. Vergewissern Sie sich, dass die Tabelle angelegt wurde. 
SELECT * FROM MY_EMPLOYEE;


-- 3. Starten Sie eine explizite Transaktion
START TRANSACTION;

-- 4. F�gen sie die erste Zeile in die Tabelle MY_EMPLOYEE von den folgenden Beispielsdaten ein, 
-- ohne die Spalten  beim INSERT aufzulisten.
-- ID   LAST_NAME   FIRST NAME    USERID    SALARY
-- 1    Patel       Ralph         rpatel      895
-- 2    Dancs       Betty         bdancs      860
-- 3    Muster3     Otto          mot3        1100
-- 4    Muster4     Otto          mot4        750


INSERT INTO my_employee
VALUES (1, 'Patel', 'Ralph', 'rpatel', 895);


-- 5. F�llen Sie die MY EMPLOYEE Tabelle mit der 2. und 3. Zeile der Beispielsdaten,
-- diemal mit expliziter Nennung der Spalten in der INSERT-Klausel.

INSERT INTO my_employee (id, lastname, firstname, userid, salary)
VALUES (2, 'Dancs', 'Betty', 'bdancs', 860);
INSERT INTO my_employee (id, lastname, firstname, userid, salary)
VALUES (3, 'Muster3', 'Otto', 'mot3', 1100);


-- 6. Schreiben Sie die �nderungen fest.

COMMIT ;


-- 7. Starten Sie eine neue Transaktion
START TRANSACTION;


-- 8. �ndern Sie den Namen des Angestellten 3 zu Drexler.

UPDATE	my_employee
SET	lastname = 'Drexler'
WHERE	id = 3;



-- 9. �ndern Sie das Gehalt f�r alle Angestellten, die weniger als 900 verdienen, auf 1000.

UPDATE	my_employee
SET	salary = 1000
WHERE	salary < 900;



-- 10. L�schen Sie Betty Dancs aus der Tabelle MY_EMPLOYEE.
DELETE
FROM my_employee
WHERE lastname = 'Dancs';



-- 11. Schreiben Sie alle anstehenden �nderungen fest.

COMMIT;


-- 12. STARTEN SIE eine neue Transaktion

START TRANSACTION;

-- 13. F�llen Sie die MY_EMPLOYEE Tabelle mit der 4. Zeile der Beispielsdaten.

INSERT INTO my_employee (id, lastname, firstname, userid, salary)
VALUES (4, 'Muster4', 'Otto', 'mot4', 750);




-- 14. Setzen Sie einen Zwischenpunkt (Savepoint) in der laufenden Transaktion. 

SAVEPOINT step_14;



-- 15. Leeren Sie die gesamte Tabelle.

DELETE
FROM my_employee;



-- 16. Machen Sie das L�schen r�ckg�ngig ohne die vorherige INSERT-Anweisung r�ckg�ngig zu machen. 

ROLLBACK TO step_14;



-- 17. Schreiben Sie die Daten endg�ltig fest.

COMMIT;

-- nur zur Abfrage des Ergebnisses:
SELECT * FROM MY_EMPLOYEE;
-- nur zum Aufr�umen
DROP TABLE MY_EMPLOYEE;