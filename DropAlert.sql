
-- Select Alerts
USE msdb;
SELECT * FROM sysalerts;


-- Use a instrução sp_delete_alert para remover um alert específico pelo nome
USE msdb; -- Certifique-se de estar no banco de dados msdb
EXEC msdb.dbo.sp_delete_alert @name = 'NOME DO ALERTA';


