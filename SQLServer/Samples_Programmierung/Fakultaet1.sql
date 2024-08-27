/* Erstellen Sie für die Fakultätsberechnung eine entsprechende 
*  Funktion (zur Erinnerung: Für positive Ganzzahlen n ist die
*  Fakultät das Produkt der Zahlen von 1 bis n).
*  Leider ist TRY ... CATCH und auch THROW bzw. RAISEERROR
*  innerhalb von Funktionen nicht erlaubt.
*  Wie können wir trotzdem einen Fehler signalisieren?
*  Testen Sie die Funktion durch Aufruf
*/

CREATE OR ALTER FUNCTION fakultaet(@n int)
	RETURNS int
	AS
	BEGIN
		DECLARE @result int = 1;
		DECLARE @counter int = 1;
		IF @n < 1
			BEGIN
				-- return @n/0;   -- Fehlermeldung passt nicht
				return null;   -- auch nicht toll
				-- return -1;   -- auch nicht toll
			END;
		WHILE @counter <= @n
			BEGIN
				SET @result = @result * @counter;
				SET @counter +=1;
			END
		RETURN @result;
	END;

GO

-- Funktionsaufrufe immer mit (...) und Schema-Namen
SELECT dbo.fakultaet(5);
SELECT dbo.fakultaet(20);  --Overflow: gibt Standard-Fehler
SELECT dbo.fakultaet(-1);

GO

/* Können Sie auch eine rekursive Variante schreiben?
*  Hinweis:  Fakultaet(1) = 1 und 
*  und für n > 1 gilt: Fakultaet(n) = n *Fakultaet(n-1)
*  Allerdings beschränkt SQL Server den Call-Stack 
*  drastisch auf 32 (zumindest in Versionen bis 2022).
*/

CREATE OR ALTER FUNCTION fakrek(@n int)
	RETURNS int
	AS
	BEGIN
		-- hier ohne Fehlerbehandlung
		IF @n = 1	RETURN 1;
		RETURN @n * dbo.fakrek(@n-1);
	END;

GO

SELECT dbo.fakrek(5);
SELECT dbo.fakrek(20);  --Overflow: gibt Standard-Fehler
