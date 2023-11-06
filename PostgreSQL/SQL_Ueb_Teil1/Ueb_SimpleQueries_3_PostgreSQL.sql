-- Übung: Verwendung von Funktionen

-- 1.	Zeigen Sie für jeden Mitarbeiter die Mitarbeiternummer, den Nachnamen, 
-- das Gehalt und das Gehalt mit 15% Zuwachs, diesen Wert als Ganzzahl und mit 
-- der Überschrift “New Salary”.




-- 2.	Verändern Sie die vorhergehende Abfrage so, dass eine zusätzliche Spalte 
-- mit dem Bezeichner „Increase“ angezeigt wird, die das alte vom neuen 
-- Gehalt abzieht.


  
  
-- 3.	Schreiben Sie eine Abfrage, die den Nachnamen des Mitarbeiters, beginnend
-- mit einem Großbuchstaben und den Rest in Kleinschreibung, und die Länge des 
-- Namens anzeigt, für die Mitarbeiter, deren Nachname mit J, A oder M beginnt. 
-- Geben Sie den Spalten entsprechende Bezeichner und sortieren Sie die Ausgabe
-- nach den Namen.



 
-- 4.	Zeigen Sie für alle Mitarbeiter den Nachnamen und die Anzahl der 
-- Kalendermonate zwischen dem aktuellen Datum und dem Einstellungsdatum, 
-- sortiert nach der Anzahl Monate. 
-- Zwischen dem 30.01.2005 und dem 01.02.2005 sollte schon ein Monat liegen,
-- d.h es geht um Kalendermonate !!
-- das wird ein wenig Gefummel in PostgreSQL: DATE_PART() kann helfen.



-- 5.	Schreiben Sie eine Abfrage um den Nachnamen und das Gehalt aller 
-- Mitarbeiter anzuzeigen. Formatieren Sie die Ausgabe des Gehalts auf 15 
-- Stellen, links aufgefüllt mit „$“, unter dem Bezeichner „Salary“.




-- 6.	Schreiben Sie eine Abfrage, die den Nachnamen und die Managerkennung der
-- Mitarbeiter anzeigt. Falls der Mitarbeiter keinen Manager hat, soll 
-- „No Manager“ ausgegeben werden.



 
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




-- 8. Schreiben Sie eine Abfrage, um eine Einstufung der Abteilungen auf Basis 
-- ihrer Abteilungskennung in folgender Form anzuzeigen:
-- "Department_Name			Level". 
-- Dabei sollen Abteilungen mit einer Kennung < 100 den Level "< 100", 
-- Abteilungen mit einer Kennung zwischen 100 und 200 den Level "100 - 200" 
-- und Abteilungen mit einer Kennung > 200 den Level "> 200" erhalten.


 

