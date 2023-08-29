/* main.sql */

USE [master];

/* LOGIN AND USER */

CREATE LOGIN [chatapp] WITH PASSWORD=N'chatapp', DEFAULT_DATABASE=[chatdb]; GO

USE [chatdb];

CREATE USER [chatapp] FOR LOGIN [chatapp]; GO

/* SCHEMAS */

CREATE SCHEMA enum; GO
CREATE SCHEMA social; GO
CREATE SCHEMA io; GO

/* TABLES */

CREATE TABLE [social].[User](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[username] VARCHAR(20) NOT NULL,
	[password] VARCHAR(100) NOT NULL,
	[email] VARCHAR(50) NOT NULL,
	[lastOnline] DATETIME NOT NULL,
	[joinedAt] DATETIME NOT NULL
) ON [PRIMARY];
GO

CREATE TABLE [social].[Group](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[name] VARCHAR(20) NOT NULL,
	[createdAt] DATETIME NOT NULL,
	[lastActivity] DATETIME NOT NULL
) ON [PRIMARY];
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
) ON [PRIMARY];
GO

CREATE TABLE [enum].[MemberRole](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[role] VARCHAR(20) NOT NULL
) ON [PRIMARY];
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
) ON [PRIMARY];
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
) ON [PRIMARY];
GO

CREATE TABLE [enum].[RelationshipStatus](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[status] VARCHAR(20) NOT NULL
) ON [PRIMARY];
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
) ON [PRIMARY];
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
) ON [PRIMARY];
GO

CREATE TABLE [io].[GroupMessageAttachment](
	[id] INT PRIMARY KEY IDENTITY(1, 1),
	[filename] VARCHAR(200) NOT NULL,
	[messageId] INT NOT NULL,
	CONSTRAINT FK_GroupMessageAttachment_MessageId FOREIGN KEY (messageId)
		REFERENCES [io].[GroupMessage](id)
) ON [PRIMARY];
GO


/* CONSTRAINTS */

ALTER TABLE [social].[User] WITH CHECK
	ADD CONSTRAINT [CK_User_username_length] CHECK ((len([username])>(2) AND len([username])<(21))); GO

ALTER TABLE [social].[Relationship] WITH CHECK
    ADD CONSTRAINT [CK_Relationship_user1Id_less_than_User2Id] CHECK ([user1Id] < [user2Id]); GO

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

CREATE OR ALTER TRIGGER [tr_Relationship_InsertUpdate] ON [social].[Relationship]
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @currentTime DATETIME = GETDATE();
    DECLARE @user1Id INT = (SELECT user1Id from inserted);
    DECLARE @user2Id INT = (SELECT user2Id from inserted);

    UPDATE [social].[Relationship]
        SET lastUpdatedAt = @currentTime
        WHERE user1Id = @user1Id AND user2Id = @user2Id;
END
GO


/* STORED PROCEDURES */

-- USER

CREATE OR ALTER PROCEDURE [social].[usp_GetAllUsers] AS
	SELECT id, username, email, lastOnline, joinedAt FROM [social].[User];
GO

CREATE OR ALTER PROCEDURE [social].[usp_CreateUser] (@username AS VARCHAR(20),
                                            @password AS VARCHAR(100),
                                            @email AS VARCHAR(50)) AS
BEGIN
    INSERT INTO [social].[User] (username, password, email, lastOnline, joinedAt)
    VALUES (@username, @password, @email, GETDATE(), GETDATE());
END
GO

-- GROUP

CREATE OR ALTER PROCEDURE [social].[usp_CreateGroup] (@name AS VARCHAR(20)) AS
BEGIN
    INSERT INTO [social].[Group] (name, createdAt, lastActivity)
    VALUES (@name, GETDATE(), GETDATE());
END
GO

CREATE OR ALTER PROCEDURE [social].[usp_KickMemberFromGroup] (@groupId AS INT, @userId AS INT) AS
BEGIN
    DELETE FROM [social].[Member]
           WHERE groupId = @groupId AND userId = @userId;
END
GO

-- GROUP MEMBER

CREATE OR ALTER PROCEDURE [social].[usp_AddMember] (@groupId AS INT, @userId AS INT) AS
BEGIN
    DECLARE @userRoleId INT = (SELECT id FROM [enum].[MemberRole] WHERE role = 'ROLE_MEMBER')

    INSERT INTO [social].[Member] (groupId, userId, roleId, joinedAt)
    VALUES (@groupId, @userId, @userRoleId, GETDATE());
END
GO

-- GROUP MESSAGES

CREATE OR ALTER PROCEDURE [io].[usp_GetLastNGroupMessages] (@groupId AS INT, @n AS INT) AS
BEGIN
    SELECT TOP(@n) id, authorId, groupId, content, createdAt FROM [io].[GroupMessage] WHERE groupId = @groupId ORDER BY id DESC;
END
GO

CREATE OR ALTER PROCEDURE [io].[usp_SendGroupMessage] (@authorId AS INT, @groupId AS INT, @content AS VARCHAR(5000)) AS
BEGIN
    INSERT INTO [io].[GroupMessage] (authorId, groupId, content, createdAt)
    VALUES (@authorId, @groupId, @content, GETDATE());
END
GO

-- RELATIONSHIP

CREATE OR ALTER PROCEDURE [social].[usp_GetAllRelationshipsOfUser] (@userId AS INT) AS
BEGIN
    SELECT * FROM [social].[Relationship] WHERE user1Id = @userId OR user2Id = @userId;
END
GO

CREATE OR ALTER PROCEDURE [social].[usp_SendFriendRequest] (@requesterId AS INT, @targetId AS INT) AS
BEGIN
    DECLARE @user1 INT;
    DECLARE @user2 INT;
    DECLARE @statusId INT;

    -- TODO check whether relationship exists

    IF @requesterId < @targetId
    BEGIN
        SET @user1 = @requesterId;
        SET @user2 = @targetId;
        SET @statusId = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'pending_first_second');
    END
    ELSE
    BEGIN
        SET @user1 = @targetId;
        SET @user2 = @requesterId;
        SET @statusId = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'pending_second_first');
    END

    INSERT INTO [social].[Relationship] (user1Id, user2Id, statusId, lastUpdatedAt)
    VALUES (@user1, @user2, @statusId, GETDATE());
END
GO

CREATE OR ALTER PROCEDURE [social].[usp_AcceptFriendRequest] (@acceptorId AS INT, @requesterId AS INT) AS
BEGIN
    DECLARE @statusId INT = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'friends');
    DECLARE @prevStatusId INT;

    IF @acceptorId < @requesterId
    BEGIN
        SET @prevStatusId = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'pending_second_first');
        UPDATE [social].[Relationship]
            SET statusId = @statusId
            WHERE user1Id = @acceptorId AND user2Id = @requesterId AND statusId = @prevStatusId;
    END
    ELSE
    BEGIN
        SET @prevStatusId = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'pending_first_second');
        UPDATE [social].[Relationship]
            SET statusId = @statusId
            WHERE user1Id = @requesterId AND user2Id = @acceptorId AND statusId = @prevStatusId;
    END
END
GO

CREATE OR ALTER PROCEDURE [social].[usp_RejectFriendRequest] (@rejectorId AS INT, @requesterId AS INT) AS
BEGIN
    DECLARE @prevStatusId INT;

    IF @rejectorId < @requesterId
        BEGIN
            SET @prevStatusId = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'pending_second_first');
            DELETE FROM [social].[Relationship]
                WHERE user1Id = @rejectorId AND user2Id = @requesterId AND statusId = @prevStatusId;
        END
    ELSE
        BEGIN
            SET @prevStatusId = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'pending_first_second');
            DELETE FROM [social].[Relationship]
                WHERE user1Id = @requesterId AND user2Id = @rejectorId AND statusId = @prevStatusId;
        END
END
GO

CREATE OR ALTER PROCEDURE [social].[usp_CancelFriendRequest] (@cancellerId AS INT, @targetId AS INT) AS
BEGIN
    DECLARE @prevStatusId INT;

    IF @cancellerId < @targetId
        BEGIN
            SET @prevStatusId = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'pending_first_second');
            DELETE FROM [social].[Relationship]
                WHERE user1Id = @cancellerId AND user2Id = @targetId AND statusId = @prevStatusId;
        END
    ELSE
        BEGIN
            SET @prevStatusId = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'pending_second_first');
            DELETE FROM [social].[Relationship]
                WHERE user1Id = @targetId AND user2Id = @cancellerId AND statusId = @prevStatusId;
        END
END
GO

CREATE OR ALTER PROCEDURE [social].[usp_RemoveFromFriends] (@removerId AS INT, @friendId AS INT) AS
BEGIN
    DECLARE @prevStatusId INT = (SELECT id FROM [enum].[RelationshipStatus] WHERE status = 'friends');

    IF @removerId < @friendId
        BEGIN
            DELETE FROM [social].[Relationship]
                WHERE user1Id = @removerId AND user2Id = @friendId AND statusId = @prevStatusId;
        END
    ELSE
        BEGIN
            DELETE FROM [social].[Relationship]
                WHERE user1Id = @friendId AND user2Id = @removerId AND statusId = @prevStatusId;
        END
END
GO

/* PERMISSIONS */

-- TABLE (AND COLUMN) PERMISSIONS
GRANT SELECT ON [social].[User] TO chatapp;
GRANT SELECT ON [social].[Group] TO chatapp;
GRANT SELECT ON [social].[Member] TO chatapp;
GO

GRANT SELECT, INSERT ON [io].[GroupMessage] TO chatapp;
DENY DELETE ON [io].[GroupMessage] TO chatapp;
GO

-- EXECUTE STORED PROCEDURES PERMISSIONS
GRANT EXECUTE ON OBJECT::[social].[usp_GetAllUsers] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_CreateUser] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_CreateGroup] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_KickMemberFromGroup] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_AddMember] TO chatapp;
GRANT EXECUTE ON OBJECT::[io].[usp_GetLastNGroupMessages] TO chatapp;
GRANT EXECUTE ON OBJECT::[io].[usp_SendGroupMessage] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_GetAllRelationshipsOfUser] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_SendFriendRequest] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_AcceptFriendRequest] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_RejectFriendRequest] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_CancelFriendRequest] TO chatapp;
GRANT EXECUTE ON OBJECT::[social].[usp_RemoveFromFriends] TO chatapp;
GO


/* INSERT DATA */

INSERT [enum].[MemberRole] ([role])
VALUES
    ('ROLE_ADMIN'),
    ('ROLE_MEMBER')
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

EXEC [social].[usp_CreateUser]
    @username = 'LuckyLuke',
    @password = '$2a$10$slRHinySi9/4ZIyhtKtwJ.MT0zqjRLwIVghqQC0rg5NYAktKa9fK.',
    @email = 'luckyluke@mail.com'; GO
EXEC [social].[usp_CreateUser]
    @username = 'JollyJumper',
    @password = '$2a$10$IVEs5.NToJV7rLFhIIs.6udG4KjuOK7x5qPMXKUv7iTXiVNno1SpK',
    @email = 'jollyjumper@mail.com'; GO
EXEC [social].[usp_CreateUser]
    @username = 'Rantanplan',
    @password = '$2a$10$9YforYi5MKMDKUd3DiKhX.7Um4M4.cEw7RoYQe9ZPkiWYDskWEhqK',
    @email = 'rantanplan@mail.com'; GO

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
EXEC [io].[usp_SendGroupMessage] @authorId = 1, @groupId = 1, @content = N'This is a short message'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 1, @groupId = 1, @content = N'Lorem ipsum dolor sit amet,
    consectetur adipiscing elit. Duis at massa ac nisl condimentum scelerisque. Phasellus semper lorem velit,
    eget pharetra neque tristique commodo. Sed consequat orci a semper placerat. Suspendisse in erat egestas,
    porta nisl ut, bibendum arcu. Quisque lacinia dapibus maximus. Mauris tempus mauris eget velit mattis ornare.
    Aenean non consectetur tellus, vitae volutpat ligula. Vivamus a vulputate orci, id posuere est.
    Cras commodo convallis urna, eu imperdiet velit iaculis sed. In accumsan cursus mollis.
    Duis sit amet orci blandit, imperdiet dolor eget, iaculis ex. Quisque et lorem vel lacus dictum aliquet et
    at lectus. Aliquam erat volutpat. In vitae orci feugiat, congue diam eget, ullamcorper neque.
    Curabitur suscipit et diam sed posuere. Curabitur libero lacus, ultricies ut ultrices sed, sodales at libero.
    Aliquam a metus vitae augue elementum tincidunt. Sed egestas volutpat lacus, id consequat orci posuere eget.
    Fusce vehicula quam efficitur fringilla ullamcorper.'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 1, @groupId = 1, @content = N'I wonder how that lorem will render...'; GO
EXEC [io].[usp_SendGroupMessage] @authorId = 2, @groupId = 1, @content = N'Hello!'; GO

EXEC [social].[usp_SendFriendRequest] @requesterId = 1, @targetId = 2; GO
EXEC [social].[usp_SendFriendRequest] @requesterId = 2, @targetId = 3; GO
EXEC [social].[usp_SendFriendRequest] @requesterId = 3, @targetId = 1; GO

EXEC [social].[usp_AcceptFriendRequest] @acceptorId = 1, @requesterId = 3; GO
EXEC [social].[usp_AcceptFriendRequest] @acceptorId = 3, @requesterId = 2; GO
EXEC [social].[usp_AcceptFriendRequest] @acceptorId = 2, @requesterId = 1; GO

-- EXEC [social].[usp_CancelFriendRequest] @cancellerId = 1, @targetId = 2; GO

-- EXEC [social].[usp_RejectFriendRequest] @rejectorId = 1, @requesterId = 3; GO
-- EXEC [social].[usp_RejectFriendRequest] @rejectorId = 2, @requesterId = 1; GO

-- EXEC [social].[usp_RemoveFromFriends] @removerId = 1, @friendId = 3; GO
-- EXEC [social].[usp_RemoveFromFriends] @removerId = 2, @friendId = 1; GO
