/* CLEANUP */
USE master;

ALTER SERVER AUDIT My_Audit WITH (STATE = OFF); GO
DROP SERVER AUDIT My_Audit; GO

USE chatdb;

ALTER DATABASE AUDIT SPECIFICATION Audit_DataManipulation WITH (STATE = OFF); GO
DROP DATABASE AUDIT SPECIFICATION Audit_DataManipulation; GO

DROP USER IF EXISTS DB_Admin; GO
DROP ROLE IF EXISTS DB_Admins; GO

DROP APPLICATION ROLE chatapp; GO

DROP SYMMETRIC KEY MySymmetricKey; GO
DROP ASYMMETRIC KEY MyAsymmetricKey; GO
DROP MASTER KEY; GO

DROP PROCEDURE IF EXISTS [social].[usp_GetAllUsers]; GO
DROP PROCEDURE IF EXISTS [social].[usp_GetUserByUsername]; GO
DROP PROCEDURE IF EXISTS [social].[usp_AuthenticateUser]; GO
DROP PROCEDURE IF EXISTS [social].[usp_CreateUser]; GO
DROP PROCEDURE IF EXISTS [social].[usp_CreateGroup]; GO
DROP PROCEDURE IF EXISTS [social].[usp_AddMember]; GO
DROP PROCEDURE IF EXISTS [io].[usp_GetLastNGroupMessages]; GO
DROP PROCEDURE IF EXISTS [io].[usp_SendGroupMessage]; GO

DROP FUNCTION IF EXISTS [social].[fn_Compare]; GO

DROP TABLE IF EXISTS [io].[GroupMessageAttachment]; GO
DROP TABLE IF EXISTS [io].[Notification]; GO
DROP TABLE IF EXISTS [social].[Relationship]; GO
DROP TABLE IF EXISTS [enum].[RelationshipStatus]; GO
DROP TABLE IF EXISTS [io].[PrivateMessage]; GO
DROP TABLE IF EXISTS [social].[Member]; GO
DROP TABLE IF EXISTS [enum].[MemberRole]; GO
DROP TABLE IF EXISTS [io].[GroupMessage]; GO
DROP TABLE IF EXISTS [social].[Group]; GO
DROP TABLE IF EXISTS [social].[User]; GO

DROP SCHEMA IF EXISTS [io]; GO
DROP SCHEMA IF EXISTS [social]; GO
DROP SCHEMA IF EXISTS [enum]; GO
