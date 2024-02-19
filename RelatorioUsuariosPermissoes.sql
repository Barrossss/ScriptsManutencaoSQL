
-- QUERIE QUE MOSTRA O NOME DO USUÁRIO E QUAIS PERMISSÕES ELE TEM DENTRO DO BANCO DE DADOS

SELECT 
    logins.name AS LoginNome,
    princ.name AS UsuarioNome,
    CASE WHEN obj.type_desc = 'SCHEMA' THEN obj.name ELSE OBJECT_NAME(major_id) END AS ObjetoNome,
    obj.type_desc AS TipoObjeto,
    perm.permission_name AS Permissao,
    ISNULL(roleprinc.name, '') AS RoleNome,
    princ.create_date AS DataCriacaoUsuario, -- Adiciona a data de criação do usuário
    obj.create_date AS DataCriacaoObjeto -- Adiciona a data de criação do objeto
FROM sys.database_principals AS princ
LEFT JOIN sys.database_permissions AS perm
    ON princ.principal_id = perm.grantee_principal_id
LEFT JOIN sys.objects AS obj
    ON perm.major_id = obj.object_id
LEFT JOIN sys.database_role_members AS rolemembers
    ON princ.principal_id = rolemembers.member_principal_id
LEFT JOIN sys.database_principals AS roleprinc
    ON rolemembers.role_principal_id = roleprinc.principal_id
LEFT JOIN sys.server_principals AS logins
    ON princ.sid = logins.sid
WHERE princ.type_desc IN ('SQL_USER', 'WINDOWS_USER', 'WINDOWS_GROUP')
    AND princ.name NOT IN ('dbo', 'guest', 'public') -- Exclua usuários de sistema
    AND perm.permission_name IS NOT NULL -- Elimine usuários com permissões nulas
ORDER BY logins.name, princ.name, ObjetoNome;