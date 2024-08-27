-- =============================================
-- Author:		Stephan Karrer
-- Create date: 
-- Description:	Beispiel für protokollierenden After-Trigger auf der JOBS-Tabelle
-- =============================================
USE HR;
GO
/* Erzeugung der Log-Tabelle */
CREATE TABLE protocoll ( wer VARCHAR(128),
                         wann DATETIME,
						 aktion VARCHAR(6),
						 jobid_old VARCHAR(10),
						 jobtitle_old VARCHAR(35),
						 minsal_old DECIMAL(6,0),
						 maxsal_old DECIMAL(6,0),
						 jobid_neu VARCHAR(10),
						 jobtitle_neu VARCHAR(35),
						 minsal_neu DECIMAL(6,0),
						 maxsal_neu DECIMAL(6,0)
						 );
GO

/* Erzeugung des Triggers	*/	
CREATE OR ALTER TRIGGER jobs_logger 
   ON  jobs
   AFTER  INSERT, DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;  -- verhindert die üblichen Ausgaben
	
	-- jetzt der eigentliche Triggercode
	DECLARE @action VARCHAR(6);
	-- Fallunterscheidung ob INSERT, UPDATE oder DELETE
	IF ((SELECT COUNT(*) FROM inserted) = 0)  
	  BEGIN SET @action = 'DELETE';
	  END
	  ELSE IF ((SELECT COUNT(*) FROM deleted) = 0)
		BEGIN SET @action = 'INSERT';
		END
	    ELSE BEGIN SET @action = 'UPDATE';
		END 
	-- Protokollierung:
	-- FULL OUTER JOIN, da ja die Hilfstabellen INSERTED und DELETED leer sein können
	INSERT INTO  [HR].[dbo].[protocoll]
		SELECT SYSTEM_USER, CURRENT_TIMESTAMP, @action, d.*, i.*
				FROM inserted i full outer join deleted d on i.job_id = d.job_id;
END
GO

/* Test des Triggers */
insert into jobs
   values ('SQL_PRG', 'SQL-Programmierer', null, null);
update jobs
    set job_title = 'test2' where job_id = 'SQL_PRG';
delete from jobs where job_id like 'SQL_PR%';
