-- IDENTIFICAR LOGIN ORFÃO

EXEC sp_change_users_login 'Report'

-- RESOLVER LOGIN ORFÃO

USE NOMEDATABASE
EXEC sp_change_users_login 'Auto_Fix', 'NOMELOGIN'