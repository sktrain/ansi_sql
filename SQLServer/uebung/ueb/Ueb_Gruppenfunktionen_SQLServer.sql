-- �bung 4: Verwendung von Gruppenfunktionen  -  L�sungen

-- 1.	Zeigen Sie das h�chste Gehalt, das niedrigste Gehalt, die Summe aller Geh�lter und das Durchschnittsgehalt 
-- f�r alle Mitarbeiter an. Runden Sie das Ergebnis auf die n�chste ganze Zahl.




-- 2.	Ver�ndern Sie die vorherige Abfrage so, dass die Werte je Jobkennung berechnet und angezeigt werden. 




-- 3.	Zeigen Sie die Jobkennungen und die Anzahl der Mitarbeiter mit diesem Job an




-- 4.	Zeigen Sie die Differenz zwischen dem niedrigsten und h�chsten Gehalt je Abteilung an. Nennen Sie die Spalte �Differenz�.




-- 5.	Bestimmen Sie die Anzahl der Manager (ohne diese aufzulisten).


 

-- 6.	Zeigen Sie je Managerkennung das Gehalt des unterstellten Angestellten mit dem niedrigsten Gehalt an. 
-- Schlie�en Sie alle Angestellten aus, deren Manager nicht bekannt ist. Schlie�en Sie alle Gruppen aus, 
-- deren Mindestgehalt 6000 oder weniger betr�gt.
-- Sortieren Sie die Ausgabe in absteigender Reihenfolge nach dem Gehalt.


  

-- 7.	Zeigen Sie die Anzahl der Mitarbeiter, deren Nachname mit dem Buchstaben �n� endet.



-- 8. Zeigen Sie die Jobkennungen, die in den Abteilungen "Administration" 
-- und "Executive" vorkommen. 
-- Zeigen Sie auch die Anzahl der Mitarbeiter f�r diese Jobs an, wobei die Ausgabe nach 
-- der Anzahl sortiert erfolgen soll.

  
  
-- 9. Zeigen Sie f�r alle Mitarbeiter, deren Managerkennung kleiner 130 ist, Folgendes an:
-- Managerkennung,  Job-Kennung und Gesamtgehalt f�r jede Jobkennung, sortiert nach der Managerkennung.


  
  
-- 10. Erweitern Sie Aufgabe 8, so dass zus�tzlich angezeigt wird:
-- Gesamtgehalt der Mitarbeiter unter dem jeweiligen Manager, Gesamtgehalt aller Mitarbeiter unter diesen Managern


  

-- 11. Erweitern Sie Aufgabe 9 um eine Anzeige, die deutlich macht, ob die Nullwerte in den Spalten aus der Rollup-Auswertung
-- resultieren oder auf Basis gespeicherter Nullwerte aus der Tabelle zustande kommen.


  
  
-- 12. Erweitern Sie die Abfrage aus Aufgabe 10, so dass zus�tzlich angezeigt wird:
-- Gesamtgehalt je Jobkennung unabh�ngig vom Manager




-- 13. Modifizieren Sie die Abfrage aus Aufgabe 9, so dass nur folgende Gruppierungen angezeigt werden:
-- (Abteilungskennung, Managerkennung, Jobkennung),
-- (Abteilungskennung, Jobkennung),
-- (Managerkennung, Jobkennung)




-- 14. Zeigen Sie je Kalenderjahr an, wieviele Angestellte jeweils eingestellt wurden.  



  
-- 15. Erstellen Sie eine Abfrage, um folgende Angaben f�r alle Abteilungen anzuzeigen,
-- deren Abteilungsnummer gr��er als 80 ist:
--  - Gesamtgehalt f�r jeden Job in der Abteilung
--  - Das Gesamtgehalt
--  - Das Gesamtgehalt f�r die St�dte, in denen sich Abteilungen befinden
--  - Das Geamtgehalt f�r jeden Job, unabh�ngig von der Abteilung
--  - Das Gesamtgehalt f�r jede Abteilung, unabh�ngig von der Stadt
--  - Das Gesamtgehalt f�r die Abteilungen, unabh�ngig von Job-Bezeichnung und Stadt



  
-- 16  Erstellen Sie eine Abfrage, um folgende Gruppierungen anzuzeigen:
--  - Abteilungsnummer, Jobkennung
--  - Jobkennung, Managerkennung
--  wobei die Ausgabe das Maximal- und das Minimalgehalt nach Abteilung, T�tigkeit und Manager enthalten soll
