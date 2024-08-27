USE HR;
GO

CREATE TABLE ddl_log (PostTime datetime, DB_User nvarchar(100), Event nvarchar(100), TSQL nvarchar(2000));
GO

CREATE TRIGGER droptable 
	ON DATABASE 
	FOR DROP_TABLE
	AS
	-- Zugriff auf das auslösende Ereignis
	DECLARE @data XML
	SET @data = EVENTDATA()
	-- Protokollierung des Ereignisses in der Tabelle ddl_log
	INSERT ddl_log (PostTime, DB_User, Event, TSQL) 
		 VALUES (
			GETDATE(), 
			CONVERT(nvarchar(100), 
			CURRENT_USER), 
			@data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'), 
			@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)') ) ;
	-- nur zum Test
	PRINT 'DROP TABLE Issued.'
	--SELECT * from TestTable  -- Versuch des Zugriffs

	-- Extraktion des Namens der gedroppten Tabelle
	DECLARE @tablename NVARCHAR(max);
	-- Speicherung in eigener Textvariable ist nötig, da @data.value eine Tabellenwertfunktion ist
	SELECT @tablename = @data.value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)')
	PRINT @tablename	-- nur zum Test
	--EXEC ('SELECT * INTO MyDroppedTable FROM '+@tablename); --Versuch Kopie als Tabelle zu speichern

GO


--Test the trigger
CREATE TABLE TestTable (a int);
GO

DROP TABLE TestTable ;
GO


SELECT * FROM ddl_log ;
--GO
