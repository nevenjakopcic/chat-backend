/* CLEANUP */
USE chatdb;

DROP USER chatapp; GO
DROP LOGIN chatapp; GO

DROP PROCEDURE IF EXISTS [social].[usp_GetAllUsers]; GO
DROP PROCEDURE IF EXISTS [social].[usp_CreateUser]; GO
DROP PROCEDURE IF EXISTS [social].[usp_CreateGroup]; GO
DROP PROCEDURE IF EXISTS [social].[usp_PromoteMemberToAdmin]; GO
DROP PROCEDURE IF EXISTS [social].[usp_KickMemberFromGroup]; GO
DROP PROCEDURE IF EXISTS [social].[usp_AddMember]; GO
DROP PROCEDURE IF EXISTS [io].[usp_GetLastNGroupMessages]; GO
DROP PROCEDURE IF EXISTS [io].[usp_SendGroupMessage]; GO
DROP PROCEDURE IF EXISTS [social].[usp_GetAllRelationshipsOfUser]; GO
DROP PROCEDURE IF EXISTS [social].[usp_SendFriendRequest]; GO
DROP PROCEDURE IF EXISTS [social].[usp_AcceptFriendRequest]; GO
DROP PROCEDURE IF EXISTS [social].[usp_RejectFriendRequest]; GO
DROP PROCEDURE IF EXISTS [social].[usp_CancelFriendRequest]; GO
DROP PROCEDURE IF EXISTS [social].[usp_RemoveFromFriends]; GO

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
