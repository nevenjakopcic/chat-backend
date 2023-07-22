/* main.sql */
USE chatdb


/* SCHEMAS */

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'enum')
BEGIN
	EXEC('CREATE SCHEMA enum');
END

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'social')
BEGIN
	EXEC('CREATE SCHEMA social');
END

IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'io')
BEGIN
	EXEC('CREATE SCHEMA io');
END
GO


/* TABLES */

CREATE TABLE [social].[User](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[username] VARCHAR(20) NOT NULL,
	[password] VARBINARY(4000) NOT NULL,
	[lastOnline] DATETIME NOT NULL,
	[joinedAt] DATETIME NOT NULL
) ON [PRIMARY]
GO

CREATE TABLE [social].[Group](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[name] VARCHAR(20) NOT NULL,
	[createdAt] DATETIME NOT NULL
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

CREATE UNIQUE NONCLUSTERED INDEX [IX_User_Username] ON [social].[User] ("username")
GO

CREATE NONCLUSTERED INDEX [IX_Notification_NotRead] ON [IO].[Notification] ("isRead")
WHERE isRead = 0
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

/* STORED PROCEDURES */

-- USER

CREATE PROCEDURE [social].[usp_GetAllUsers] AS
	SELECT id, username, lastOnline, joinedAt FROM [social].[User];
GO

CREATE PROCEDURE [social].[usp_GetUserByUsername] (@username AS VARCHAR(20)) AS
BEGIN
	SELECT id, username, lastOnline, joinedAt FROM [social].[User] WHERE username = @username;
END
GO

CREATE PROCEDURE [social].[usp_CreateUser] (@username AS VARCHAR(20), @password AS VARCHAR(50)) AS
BEGIN
    OPEN SYMMETRIC KEY MySymmetricKey
    DECRYPTION BY ASYMMETRIC KEY MyAsymmetricKey;

    INSERT INTO [social].[User] (username, password, lastOnline, joinedAt)
    VALUES (@username, ENCRYPTBYKEY(KEY_GUID('MySymmetricKey'), @password), GETDATE(), GETDATE());

    CLOSE SYMMETRIC KEY MySymmetricKey;
END
GO

-- GROUP MESSAGES

CREATE PROCEDURE [io].[usp_GetLastNGroupMessages] (@groupId AS INT, @n AS INT) AS
BEGIN
    SELECT TOP(@n) id, authorId, groupId, content, createdAt FROM GroupMessage WHERE groupId = @groupId;
END
GO


/* APPLICATION ROLE AND PERMISSIONS */

CREATE APPLICATION ROLE chatapp WITH PASSWORD = 'chatapp';
GO

-- TABLE (AND COLUMN) PERMISSIONS
GRANT SELECT ON [social].[User] (username, lastOnline, joinedAt) TO chatapp;
DENY SELECT ON [social].[User] (password) TO chatapp;
DENY DELETE ON [social].[User] TO chatapp;
GO

GRANT SELECT ON [io].[GroupMessage] TO chatapp;
DENY DELETE ON [io].[GroupMessage] TO chatapp;
GO

-- EXECUTE STORED PROCEDURES PERMISSIONS
GRANT EXECUTE ON OBJECT::[social].[usp_GetAllUsers] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_GetUserByUsername] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_CreateUser] TO chatapp;
GRANT EXECUTE ON OBJECT::[io].[usp_GetLastNGroupMessages] TO chatapp;
GO


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

EXEC [social].[usp_CreateUser] @username = 'LuckyLuke', @password = 'password'; GO
EXEC [social].[usp_CreateUser] @username = 'JollyJumper', @password = 'password'; GO
EXEC [social].[usp_CreateUser] @username = 'Rantanplan', @password = 'password'; GO

INSERT [social].[Group] ([name], [createdAt])
VALUES
    (N'Goodsprings', GETDATE()),
    (N'Primm', GETDATE()),
    (N'New Vegas', GETDATE())
GO

INSERT [social].[Member] ([groupId], [userId], [roleId], [joinedAt])
VALUES
    (1, 1, 1, GETDATE()),
    (1, 2, 1, GETDATE()),
    (1, 3, 2, GETDATE()),
    (2, 3, 1, GETDATE())
GO

INSERT [io].[GroupMessage] ([authorId], [groupId], [content], [createdAt])
VALUES
    (1, 1, N'First message in Goodsprings', DATEADD(mi, -5, GETDATE())),
    (2, 1, N'Second message in Goodsprings!', DATEADD(mi, -4, GETDATE())),
    (3, 2, N'Third message ever, first in Primm!', DATEADD(mi, -3, GETDATE())),
    (2, 1, N'Third message in Goodsprings', DATEADD(mi, -2, GETDATE())),
    (3, 1, N'Fourth message in Goodsprings', DATEADD(mi, -1, GETDATE()))
GO