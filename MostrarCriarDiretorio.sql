-- Mostrar diretórios
EXEC xp_fixeddrives;

-- Criar diretórios

-- Habilitar o xp_cmdshell (se ainda não estiver habilitado)
-- Isso só precisa ser feito uma vez, a menos que seja desabilitado posteriormente
-- USE master;
-- EXEC sp_configure 'show advanced options', 1;
-- RECONFIGURE;
-- EXEC sp_configure 'xp_cmdshell', 1;
-- RECONFIGURE;

-- Criar um diretório no disco F:
EXEC xp_cmdshell 'mkdir F:\NomeDoDiretorio';


-- Ver espaço livre em disco
EXEC xp_cmdshell 'FSUTIL VOLUME DISKFREE R:\ '