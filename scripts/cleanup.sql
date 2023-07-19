/* CLEANUP */

DROP ROLE IF EXISTS chatapp;
GO

DROP PROCEDURE IF EXISTS [social].[usp_GetAllUsers]; GO
DROP PROCEDURE IF EXISTS [social].[usp_GetUserByUsername]; GO
DROP PROCEDURE IF EXISTS [io].[usp_GetLastNGroupMessages]; GO

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
