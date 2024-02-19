--	 VER QUANTO DE ESPAÇO LIVRE TEM NOS DISCOS

SET NOCOUNT ON
IF OBJECT_ID(N'tempdb..#FreeDiskSize') IS NOT NULL DROP TABLE #FreeDiskSize

CREATE TABLE #FreeDiskSize (name varchar(5), available_mb int)

INSERT #FreeDiskSize(name,available_mb) 
EXEC master..XP_FIXEDDRIVES
DECLARE @Drive VARCHAR(5), @CMD VARCHAR(1000), @pos SMALLINT

IF OBJECT_ID(N'tempdb..#TotalDiskSize') IS NOT NULL DROP TABLE #TotalDiskSize

CREATE TABLE #TotalDiskSize (TotalBytes VARCHAR(1000), Drive VARCHAR(5))

DECLARE Drive_name CURSOR FOR 

SELECT name FROM #FreeDiskSize
OPEN Drive_name
FETCH NEXT FROM Drive_name INTO @Drive
WHILE @@FETCH_STATUS = 0 
BEGIN
SET @CMD='MASTER..XP_CMDSHELL ' + ''''+ 'FSUTIL VOLUME DISKFREE ' + @Drive + ': | find '+ '"Total # of bytes"'+''''
INSERT #TotalDiskSize(TotalBytes) EXEC (@CMD)
UPDATE #TotalDiskSize SET Drive=@Drive WHERE Drive IS NULL
FETCH NEXT FROM Drive_name INTO @Drive
END
CLOSE Drive_name
DEALLOCATE Drive_name
DELETE FROM #TotalDiskSize WHERE TotalBytes IS NULL
SELECT @pos=charindex(':',TotalBytes) FROM #TotalDiskSize

SELECT b.Drive as Drive, CONVERT(BIGINT,(RIGHT(b.TotalBytes,(LEN(b.TotalBytes)-@pos))))/1073741824 AS TOTAL_Drive_SPACE_GB, a.available_mb/1024 AS AVAILABLE_SPACE_GB
FROM #FreeDiskSize a WITH (NOLOCK)
INNER JOIN #TotalDiskSize b WITH (NOLOCK)ON a.name=b.Drive