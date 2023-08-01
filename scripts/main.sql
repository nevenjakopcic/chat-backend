/* main.sql */

/* MAINTENANCE AND ADMINISTRATION */
USE master;

-- SERVER AUDIT
CREATE SERVER AUDIT My_Audit TO FILE (FILEPATH = 'C:\Users\ltpt4\OneDrive\Desktop\NOSQL i BAZE\BAZE\audits'); GO
ALTER SERVER AUDIT My_Audit WITH (STATE = ON); GO

CREATE SERVER AUDIT My_Audit2 TO FILE (FILEPATH = 'C:\Users\ltpt4\OneDrive\Desktop\NOSQL i BAZE\BAZE\audits'); GO
ALTER SERVER AUDIT My_Audit2 WITH (STATE = ON); GO

USE chatdb;

-- ADMIN USER AND ROLE
CREATE USER [DB_Admin] WITHOUT LOGIN; GO
CREATE ROLE [DB_Admins]; GO
ALTER ROLE [DB_Admins] ADD MEMBER [DB_Admin]; GO


/* SCHEMAS */

EXEC('CREATE SCHEMA enum'); GO
EXEC('CREATE SCHEMA social'); GO
EXEC('CREATE SCHEMA io'); GO

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[io] TO DB_Admins; GO
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[social] TO DB_Admins; GO
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::[enum] TO DB_Admins; GO

/* TABLES */

CREATE TABLE [social].[User](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[username] VARCHAR(20) NOT NULL,
	[password] VARBINARY(4000) NOT NULL,
	[email] VARCHAR(50) NOT NULL,
	[lastOnline] DATETIME NOT NULL,
	[joinedAt] DATETIME NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [social].[Group](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[name] VARCHAR(20) NOT NULL,
	[createdAt] DATETIME NOT NULL,
	[lastActivity] DATETIME NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [io].[GroupMessage](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[authorId] INT NOT NULL,
	[groupId] INT NOT NULL,
	[content] VARCHAR(5000) NOT NULL,
	[createdAt] DATETIME NOT NULL,
	CONSTRAINT FK_GroupMessage_AuthorId FOREIGN KEY (authorId)
		REFERENCES [social].[User](id),
	CONSTRAINT FK_GroupMessage_GroupId FOREIGN KEY (groupId)
		REFERENCES [social].[Group](id)
) ON [PRIMARY]
GO

CREATE TABLE [enum].[MemberRole](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[role] VARCHAR(20) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [social].[Member](
	[groupId] INT NOT NULL,
	[userId] INT NOT NULL,
	[roleId] INT NOT NULL,
	[joinedAt] DATETIME NOT NULL,
	CONSTRAINT FK_Member_GroupId FOREIGN KEY (groupId)
		REFERENCES [social].[Group](id),
	CONSTRAINT FK_Member_UserId FOREIGN KEY (userId)
		REFERENCES [social].[User](id),
	CONSTRAINT FK_Member_RoleId FOREIGN KEY (roleId)
		REFERENCES [enum].[MemberRole](id),
	PRIMARY KEY (groupId, userId)
) ON [PRIMARY]
GO

CREATE TABLE [io].[PrivateMessage](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[authorId] INT NOT NULL,
	[recipientId] INT NOT NULL,
	[content] VARCHAR(5000) NOT NULL,
	[createdAt] DATETIME NOT NULL,
	CONSTRAINT FK_PrivateMessage_AuthorId FOREIGN KEY (authorId)
		REFERENCES [social].[User](id),
	CONSTRAINT FK_PrivateMessage_RecipientId FOREIGN KEY (recipientId)
		REFERENCES [social].[User](id)
) ON [PRIMARY]
GO

CREATE TABLE [enum].[RelationshipStatus](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[status] VARCHAR(20) NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [social].[Relationship](
	[user1Id] INT NOT NULL,
	[user2Id] INT NOT NULL,
	[statusId] INT NOT NULL,
	[lastUpdatedAt] DATETIME NOT NULL,
	CONSTRAINT FK_Relationship_User1Id FOREIGN KEY (user1Id)
		REFERENCES [social].[User](id),
	CONSTRAINT FK_Relationship_User2Id FOREIGN KEY (user2Id)
		REFERENCES [social].[User](id),
	CONSTRAINT FK_Relationship_StatusId FOREIGN KEY (statusId)
		REFERENCES [enum].[RelationshipStatus](id),
	PRIMARY KEY (user1Id, user2Id)
) ON [PRIMARY]
GO

CREATE TABLE [io].[Notification](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[recipientId] INT NOT NULL,
	[groupId] INT NOT NULL,
	[content] VARCHAR(200) NOT NULL,
	[isRead] BIT NOT NULL,
	[createdAt] DATETIME NOT NULL,
	CONSTRAINT FK_Notification_RecipientId FOREIGN KEY (recipientId)
		REFERENCES [social].[User](id),
	CONSTRAINT FK_Notification_GroupId FOREIGN KEY (groupId)
		REFERENCES [social].[Group](id),
) ON [PRIMARY]
GO

CREATE TABLE [io].[GroupMessageAttachment](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[filename] VARCHAR(200) NOT NULL,
	[messageId] INT NOT NULL,
	CONSTRAINT FK_GroupMessageAttachment_MessageId FOREIGN KEY (messageId)
		REFERENCES [io].[GroupMessage](id)
) ON [PRIMARY]
GO


/* CONSTRAINTS */

ALTER TABLE [social].[User]  WITH CHECK 
	ADD CONSTRAINT [CK_User_username_length] CHECK ((len([username])>(2) AND len([username])<(21)))
GO


/* INDEXES */

CREATE UNIQUE NONCLUSTERED INDEX [IX_User_Username] ON [social].[User] ("username"); GO

CREATE UNIQUE NONCLUSTERED INDEX [IX_User_Email] ON [social].[User] ("email"); GO

CREATE NONCLUSTERED INDEX [IX_Notification_NotRead] ON [io].[Notification] ("isRead")
WHERE isRead = 0; GO


/* TRIGGERS */

CREATE OR ALTER TRIGGER [tr_GroupMessage_Insert] ON [io].[GroupMessage]
AFTER INSERT
AS
BEGIN
    DECLARE @currentTime DATETIME = GETDATE();
    DECLARE @authorId INT = (SELECT authorId from inserted);
    DECLARE @groupId INT = (SELECT groupId from inserted);

    UPDATE [social].[User] SET lastOnline = @currentTime WHERE id = @authorId;
    UPDATE [social].[Group] SET lastActivity = @currentTime WHERE id = @groupId;
END
GO

CREATE OR ALTER TRIGGER [tr_Member_Insert] ON [social].[Member]
AFTER INSERT
AS
BEGIN
    DECLARE @currentTime DATETIME = GETDATE();
    DECLARE @groupId INT = (SELECT groupId from inserted);

    UPDATE [social].[Group] SET lastActivity = @currentTime WHERE id = @groupId;
END
GO

/* ENCRYPTION */

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MasterKeyPass';
GO

CREATE ASYMMETRIC KEY MyAsymmetricKey
WITH ALGORITHM = RSA_2048;
GO

CREATE SYMMETRIC KEY MySymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY ASYMMETRIC KEY MyAsymmetricKey
GO


/* DYNAMIC MASKING */

ALTER TABLE [social].[User] ALTER COLUMN email ADD MASKED WITH(FUNCTION = 'email()'); GO
ALTER TABLE [social].[User] ALTER COLUMN joinedAt ADD MASKED WITH(FUNCTION = 'default()'); GO


/* FUNCTIONS */

CREATE FUNCTION [social].[fn_Compare] (@first VARCHAR(MAX), @second VARCHAR(MAX)) RETURNS BIT AS
BEGIN
    DECLARE @result BIT;

    IF @first = @second
        SET @result = 1;
    ELSE
        SET @result = 0;

    RETURN @result;
END
GO


/* STORED PROCEDURES */

-- USER

CREATE PROCEDURE [social].[usp_GetAllUsers] AS
	SELECT id, username, email, lastOnline, joinedAt FROM [social].[User];
GO

CREATE PROCEDURE [social].[usp_GetUserByUsername] (@username AS VARCHAR(20)) AS
BEGIN
	SELECT id, username, email, lastOnline, joinedAt FROM [social].[User] WHERE username = @username;
END
GO

CREATE PROCEDURE [social].[usp_AuthenticateUser] (@username AS VARCHAR(20),
                                                  @password AS VARCHAR(50)) AS
BEGIN
    -- get the actual encrypted password
    DECLARE @actualEncrypted VARBINARY(4000) = (SELECT password FROM [social].[User] WHERE username = @username)

    -- decrypt it
    OPEN SYMMETRIC KEY MySymmetricKey
    DECRYPTION BY ASYMMETRIC KEY MyAsymmetricKey;

    DECLARE @actual VARCHAR(50) = (SELECT CONVERT(VARCHAR(50), DECRYPTBYKEY(@actualEncrypted)))

    CLOSE SYMMETRIC KEY MySymmetricKey;

    -- compare to the given password
    SELECT([social].[fn_Compare](@password, @actual));
END
GO

CREATE PROCEDURE [social].[usp_CreateUser] (@username AS VARCHAR(20),
                                            @password AS VARCHAR(50),
                                            @email AS VARCHAR(50)) AS
BEGIN
    OPEN SYMMETRIC KEY MySymmetricKey
    DECRYPTION BY ASYMMETRIC KEY MyAsymmetricKey;

    INSERT INTO [social].[User] (username, password, email, lastOnline, joinedAt)
    VALUES (@username, ENCRYPTBYKEY(KEY_GUID('MySymmetricKey'), @password), @email, GETDATE(), GETDATE());

    CLOSE SYMMETRIC KEY MySymmetricKey;
END
GO

-- GROUP

CREATE PROCEDURE [social].[usp_CreateGroup] (@name AS VARCHAR(20)) AS
BEGIN
    INSERT INTO [social].[Group] (name, createdAt, lastActivity)
    VALUES (@name, GETDATE(), GETDATE());
END
GO

-- GROUP MEMBER

CREATE PROCEDURE [social].[usp_AddMember] (@groupId AS INT, @userId AS INT) AS
BEGIN
    DECLARE @userRoleId INT = (SELECT id FROM [enum].[MemberRole] WHERE role = 'MEMBER')

    INSERT INTO [social].[Member] (groupId, userId, roleId, joinedAt)
    VALUES (@groupId, @userId, @userRoleId, GETDATE());
END
GO

-- GROUP MESSAGES

CREATE PROCEDURE [io].[usp_GetLastNGroupMessages] (@groupId AS INT, @n AS INT) AS
BEGIN
    SELECT TOP(@n) id, authorId, groupId, content, createdAt FROM GroupMessage WHERE groupId = @groupId ORDER BY id DESC;
END
GO

CREATE PROCEDURE [io].[usp_SendGroupMessage] (@authorId AS INT, @groupId AS INT, @content AS VARCHAR(5000)) AS
BEGIN
    INSERT INTO [io].[GroupMessage] (authorId, groupId, content, createdAt)
    VALUES (@authorId, @groupId, @content, GETDATE());
END
GO


/* IMPERSONALIZATION, APPLICATION ROLE AND PERMISSIONS */

USE [master];

CREATE LOGIN [dummy] WITH PASSWORD=N'dummy', DEFAULT_DATABASE=[tempdb]; GO
DENY VIEW ANY DATABASE TO [dummy]; GO

USE [chatdb];

CREATE USER [dummy_user] FOR LOGIN [dummy]; GO
CREATE USER [imp_user] WITHOUT LOGIN; GO
GRANT IMPERSONATE ON USER::[imp_user] to [dummy_user]; GO

CREATE APPLICATION ROLE chatapp WITH PASSWORD = 'chatapp'; GO

-- TABLE (AND COLUMN) PERMISSIONS
GRANT SELECT ON [social].[User] (username, email, lastOnline, joinedAt) TO chatapp, imp_user;
DENY SELECT ON [social].[User] (password) TO chatapp, imp_user;
DENY DELETE ON [social].[User] TO chatapp, imp_user;
GO

GRANT SELECT, INSERT ON [io].[GroupMessage] TO chatapp, imp_user;
DENY DELETE ON [io].[GroupMessage] TO chatapp, imp_user;
GO

-- EXECUTE STORED PROCEDURES PERMISSIONS
GRANT EXECUTE ON OBJECT::[social].[usp_GetAllUsers] TO chatapp, imp_user;
GRANT EXECUTE ON OBJECT::[social].[usp_GetUserByUsername] TO chatapp, imp_user;
GRANT EXECUTE ON OBJECT::[social].[usp_AuthenticateUser] TO chatapp, imp_user;
GRANT EXECUTE ON OBJECT::[social].[usp_CreateUser] TO chatapp, imp_user;
GRANT EXECUTE ON OBJECT::[social].[usp_CreateGroup] TO chatapp, imp_user;
GRANT EXECUTE ON OBJECT::[social].[usp_AddMember] TO chatapp, imp_user;
GRANT EXECUTE ON OBJECT::[io].[usp_GetLastNGroupMessages] TO chatapp, imp_user;
GRANT EXECUTE ON OBJECT::[io].[usp_SendGroupMessage] TO chatapp, imp_user;
GO

/* DATABASE AUDITS */
CREATE DATABASE AUDIT SPECIFICATION Audit_DataReading FOR SERVER AUDIT My_Audit; GO
ALTER DATABASE AUDIT SPECIFICATION Audit_DataReading FOR SERVER AUDIT My_Audit
    ADD (SELECT ON [social].[User] BY chatapp, dbo),
    ADD (SELECT ON [social].[Group] BY chatapp, dbo),
    ADD (SELECT ON [social].[Member] BY chatapp, dbo),
    ADD (SELECT ON [io].[GroupMessage] BY chatapp, dbo)
    WITH (STATE = ON); GO

CREATE DATABASE AUDIT SPECIFICATION Audit_DataManipulation FOR SERVER AUDIT My_Audit2; GO
ALTER DATABASE AUDIT SPECIFICATION Audit_DataManipulation FOR SERVER AUDIT My_Audit2
    ADD (INSERT, UPDATE ON [social].[User] BY chatapp, dbo),
    ADD (INSERT, UPDATE ON [social].[Group] BY chatapp, dbo),
    ADD (INSERT, UPDATE ON [social].[Member] BY chatapp, dbo),
    ADD (INSERT, UPDATE ON [io].[GroupMessage] BY chatapp, dbo)
        WITH (STATE = ON); GO


/* INSERT DATA */

INSERT [enum].[MemberRole] ([role])
VALUES
    ('ADMIN'),
    ('MEMBER')
GO

INSERT [enum].[RelationshipStatus] ([status])
VALUES
    ('pending_first_second'),
    ('pending_second_first'),
    ('friends'),
    ('block_first_second'),
    ('block_second_first'),
    ('block_both')
GO

EXEC [social].[usp_CreateUser] @username = 'LuckyLuke', @password = 'password', @email = 'luckyluke@mail.com'; GO
EXEC [social].[usp_CreateUser] @username = 'JollyJumper', @password = 'password', @email = 'jollyjumper@mail.com'; GO
EXEC [social].[usp_CreateUser] @username = 'Rantanplan', @password = 'password', @email = 'rantanplan@mail.com'; GO

EXEC [social].[usp_CreateGroup] @name = 'Goodsprings'; GO
EXEC [social].[usp_CreateGroup] @name = 'Primm'; GO
EXEC [social].[usp_CreateGroup] @name = 'New Vegas'; GO

EXEC [social].[usp_AddMember] @groupId = 1, @userId = 1; GO
EXEC [social].[usp_AddMember] @groupId = 1, @userId = 2; GO
EXEC [social].[usp_AddMember] @groupId = 1, @userId = 3; GO
EXEC [social].[usp_AddMember] @groupId = 2, @userId = 3; GO

EXEC [io].[usp_SendGroupMessage] @authorId = 1, @groupId = 1, @content = N'First message in Goodsprings'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 2, @groupId = 1, @content = N'Second message in Goodsprings'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 3, @groupId = 2, @content = N'Third message ever, first in Primm'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 2, @groupId = 1, @content = N'Third message in Goodsprings'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 3, @groupId = 1, @content = N'Fourth message in Goodsprings'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 1, @groupId = 1, @content = N'After the first full backup!'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 1, @groupId = 1, @content = N'After the first differential backup!'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 1, @groupId = 1, @content = N'After the first transaction log backup!'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 1, @groupId = 1, @content = N'After the second transaction log backup!'; GO
