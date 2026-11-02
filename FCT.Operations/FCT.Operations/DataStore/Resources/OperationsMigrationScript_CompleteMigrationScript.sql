IF OBJECT_ID(N'[Operations].[__EFMigrationsHistory]') IS NULL
BEGIN
    IF SCHEMA_ID(N'Operations') IS NULL EXEC(N'CREATE SCHEMA [Operations];');
    CREATE TABLE [Operations].[__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    IF SCHEMA_ID(N'Operations') IS NULL EXEC(N'CREATE SCHEMA [Operations];');
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE TABLE [Operations].[AuditMessage] (
        [MessageId] uniqueidentifier NOT NULL,
        [ProcessingEndpoint] nvarchar(100) NOT NULL,
        [MessageType] nvarchar(120) NOT NULL,
        [SentTime] datetime NOT NULL,
        [OriginatingEndpoint] nvarchar(100) NOT NULL,
        [BusinessKey] nvarchar(80) NOT NULL,
        [MessageBytes] varbinary(max) NOT NULL,
        [PropertiesBytes] varbinary(max) NOT NULL,
        [CreatedDate] datetime NOT NULL DEFAULT ((getutcdate())),
        CONSTRAINT [PK_Operations.AuditMessage] PRIMARY KEY ([MessageId], [ProcessingEndpoint])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE TABLE [Operations].[DataFixHistory] (
        [Id] int NOT NULL IDENTITY,
        [Release] nvarchar(10) NOT NULL,
        [StoryNumber] int NOT NULL,
        [Name] nvarchar(100) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_Operations.DataFixHistory] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE TABLE [Operations].[DeployedConfigVersion] (
        [Id] int NOT NULL IDENTITY,
        [Version] nvarchar(30) NOT NULL,
        [Checksum] varbinary(16) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_Operations.DeployedConfigVersion] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE TABLE [Operations].[DuplicateContract] (
        [ContractNumber] nvarchar(30) NOT NULL,
        [Version] int NOT NULL,
        [SubVersion] int NOT NULL,
        [NumDuplicateAllocations] int NOT NULL DEFAULT 0,
        [NumDuplicateContracts] int NOT NULL DEFAULT 0,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_Operations.DuplicateContract] PRIMARY KEY ([ContractNumber], [Version], [SubVersion])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE TABLE [Operations].[IntegrityCheckChangeTracking] (
        [Name] nvarchar(70) NOT NULL,
        [CurrentVersion] bigint NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_Operations.IntegrityCheckChangeTracking] PRIMARY KEY ([Name])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE TABLE [Operations].[ProcessedMessage] (
        [MessageId] nvarchar(36) NOT NULL,
        [ProcessingEndpoint] nvarchar(100) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_Operations.ProcessedMessage] PRIMARY KEY ([MessageId], [ProcessingEndpoint])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE TABLE [Operations].[Session] (
        [Identifier] uniqueidentifier NOT NULL,
        [CreatedDate] datetime NOT NULL DEFAULT ((getutcdate())),
        CONSTRAINT [PK_Operations.Session] PRIMARY KEY ([Identifier])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE NONCLUSTERED INDEX [IX_AUDITMESSAGE_CREATED_DATE] ON [Operations].[AuditMessage] ([CreatedDate]);
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE INDEX [IX_AuditMessage_MessageType] ON [Operations].[AuditMessage] ([MessageType]);
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE UNIQUE INDEX [IX_DataFixHistory_ReleaseStoryNumberName] ON [Operations].[DataFixHistory] ([Release], [StoryNumber], [Name]);
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    INSERT INTO [Operations].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20211026130707_Initial', N'5.0.1');
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
     CREATE TABLE [Operations].[Connectivity] (
        [ServiceName] nvarchar(50) NOT NULL,
        [CanConnect] bit NOT NULL,
        [ErrorInfo] nvarchar(500) NULL,
        [SupplementaryInfo] nvarchar(500) NULL,
        [LastUpdated] datetime2 NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_Operations.Connectivity] PRIMARY KEY ([ServiceName])
    );
END;
GO

COMMIT;
GO

