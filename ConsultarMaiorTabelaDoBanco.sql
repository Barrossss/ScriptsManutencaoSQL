
-- CONFERIR QUAL A MAIOR TABELA DO BANCO DE DADOS

SELECT 
    t.NAME AS TableName,
    SUM(p.rows) AS RowCounts
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
WHERE 
    t.is_ms_shipped = 0
GROUP BY 
    t.Name
ORDER BY 
    SUM(p.rows) DESC;
