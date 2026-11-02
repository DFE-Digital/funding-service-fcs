IF OBJECT_ID(N'[FundingAllocation].[__EFMigrationsHistory]') IS NULL
BEGIN
    IF SCHEMA_ID(N'FundingAllocation') IS NULL EXEC(N'CREATE SCHEMA [FundingAllocation];');
    CREATE TABLE [FundingAllocation].[__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20201216150928_AddFundingAllocationPageControl')
BEGIN
    IF SCHEMA_ID(N'FundingAllocation') IS NULL EXEC(N'CREATE SCHEMA [FundingAllocation];');
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20201216150928_AddFundingAllocationPageControl')
BEGIN
    CREATE TABLE [FundingAllocation].[FundingAllocationPageControl] (
        [ReadId] int NOT NULL,
        [PageNumber] int NOT NULL,
        [LatestBookmarkOnPage] nvarchar(100) NULL,
        [HaveRead] bit NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_FundingAllocationPageControl] PRIMARY KEY ([ReadId], [PageNumber]),
        CONSTRAINT [AK_FundingAllocationPageControl_PageNumber] UNIQUE ([PageNumber])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20201216150928_AddFundingAllocationPageControl')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20201216150928_AddFundingAllocationPageControl', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20201216151225_AddFundingAllocation')
BEGIN
    CREATE TABLE [FundingAllocation].[FundingAllocation] (
        [FundingAllocationId] int NOT NULL IDENTITY,
        [FundingId] nvarchar(200) NOT NULL,
        [FundingVersion] nvarchar(50) NULL,
        [FundingType] nvarchar(100) NULL,
        [Period] nvarchar(50) NULL,
        [ContractType] nvarchar(200) NULL,
        [AllocationFundingStream] nvarchar(50) NULL,
        [FSPGroup] nvarchar(100) NULL,
        [UKPRN] nvarchar(50) NULL,
        [Provider] nvarchar(200) NULL,
        [Status] nvarchar(50) NULL,
        [Substatus] nvarchar(50) NULL,
        [Value] decimal(18,2) NULL,
        [CreatedOn] datetime2 NULL,
        [CreatedBy] nvarchar(100) NULL,
        [ModifiedOn] datetime2 NULL,
        [ModifiedBy] nvarchar(100) NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_FundingAllocation] PRIMARY KEY ([FundingAllocationId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20201216151225_AddFundingAllocation')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20201216151225_AddFundingAllocation', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210104120904_AlterFundingAllocationPrimaryKeyToFundingId')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [PK_FundingAllocation];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210104120904_AlterFundingAllocationPrimaryKeyToFundingId')
BEGIN
    DECLARE @var0 sysname;
    SELECT @var0 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'FundingAllocationId');
    IF @var0 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var0 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [FundingAllocationId];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210104120904_AlterFundingAllocationPrimaryKeyToFundingId')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD CONSTRAINT [PK_FundingAllocation] PRIMARY KEY ([FundingId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210104120904_AlterFundingAllocationPrimaryKeyToFundingId')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210104120904_AlterFundingAllocationPrimaryKeyToFundingId', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210104121141_AlterFundingAllocationAddPageColumns')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [PageIndex] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210104121141_AlterFundingAllocationAddPageColumns')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [PageNumber] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210104121141_AlterFundingAllocationAddPageColumns')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210104121141_AlterFundingAllocationAddPageColumns', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210104170815_ReadSequence')
BEGIN
    CREATE SEQUENCE FundingAllocation.Read_seq  
                START WITH 1
                INCREMENT BY 1; 
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210104170815_ReadSequence')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210104170815_ReadSequence', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210107110530_AlterFundingAllocationCreateIndexPageNumber')
BEGIN
    CREATE INDEX [IX_FundingAllocation_PageNumber] ON [FundingAllocation].[FundingAllocation] ([PageNumber]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210107110530_AlterFundingAllocationCreateIndexPageNumber')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210107110530_AlterFundingAllocationCreateIndexPageNumber', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108151509_AlterFundingAllocationDropUnusedColumns')
BEGIN
    DECLARE @var1 sysname;
    SELECT @var1 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'CreatedBy');
    IF @var1 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var1 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [CreatedBy];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108151509_AlterFundingAllocationDropUnusedColumns')
BEGIN
    DECLARE @var2 sysname;
    SELECT @var2 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'CreatedOn');
    IF @var2 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var2 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [CreatedOn];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108151509_AlterFundingAllocationDropUnusedColumns')
BEGIN
    DECLARE @var3 sysname;
    SELECT @var3 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'ModifiedBy');
    IF @var3 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var3 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [ModifiedBy];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108151509_AlterFundingAllocationDropUnusedColumns')
BEGIN
    DECLARE @var4 sysname;
    SELECT @var4 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'ModifiedOn');
    IF @var4 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var4 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [ModifiedOn];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108151509_AlterFundingAllocationDropUnusedColumns')
BEGIN
    DECLARE @var5 sysname;
    SELECT @var5 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'Provider');
    IF @var5 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var5 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [Provider];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108151509_AlterFundingAllocationDropUnusedColumns')
BEGIN
    DECLARE @var6 sysname;
    SELECT @var6 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'Status');
    IF @var6 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var6 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [Status];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108151509_AlterFundingAllocationDropUnusedColumns')
BEGIN
    DECLARE @var7 sysname;
    SELECT @var7 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'Substatus');
    IF @var7 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var7 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [Substatus];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108151509_AlterFundingAllocationDropUnusedColumns')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210108151509_AlterFundingAllocationDropUnusedColumns', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108152047_AlterFundingAllocationPageControlDropColumnHaveRead')
BEGIN
    DECLARE @var8 sysname;
    SELECT @var8 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocationPageControl]') AND [c].[name] = N'HaveRead');
    IF @var8 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocationPageControl] DROP CONSTRAINT [' + @var8 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocationPageControl] DROP COLUMN [HaveRead];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210108152047_AlterFundingAllocationPageControlDropColumnHaveRead')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210108152047_AlterFundingAllocationPageControlDropColumnHaveRead', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210112085806_CreateProviderAndProfilePeriodTables')
BEGIN
    CREATE TABLE [FundingAllocation].[ProviderFundingAllocation] (
        [ProviderFundingId] nvarchar(100) NOT NULL,
        [FundingId] nvarchar(200) NOT NULL,
        [DeliveryUkprn] int NOT NULL,
        CONSTRAINT [PK_ProviderFundingAllocation] PRIMARY KEY ([ProviderFundingId]),
        CONSTRAINT [FK_ProviderFundingAllocation_FundingAllocation_FundingId] FOREIGN KEY ([FundingId]) REFERENCES [FundingAllocation].[FundingAllocation] ([FundingId]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210112085806_CreateProviderAndProfilePeriodTables')
BEGIN
    CREATE TABLE [FundingAllocation].[FundingAllocationProfilePeriod] (
        [ProviderFundingId] nvarchar(100) NOT NULL,
        [Period] int NOT NULL,
        [PlannedValue] decimal(18,2) NOT NULL,
        CONSTRAINT [PK_FundingAllocationProfilePeriod] PRIMARY KEY ([ProviderFundingId], [Period]),
        CONSTRAINT [FK_FundingAllocationProfilePeriod_ProviderFundingAllocation_ProviderFundingId] FOREIGN KEY ([ProviderFundingId]) REFERENCES [FundingAllocation].[ProviderFundingAllocation] ([ProviderFundingId]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210112085806_CreateProviderAndProfilePeriodTables')
BEGIN
    CREATE INDEX [IX_ProviderFundingAllocation_FundingId] ON [FundingAllocation].[ProviderFundingAllocation] ([FundingId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210112085806_CreateProviderAndProfilePeriodTables')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210112085806_CreateProviderAndProfilePeriodTables', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210112151037_AlterFundingAllocationAddColumnProviderFundingCount')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [ProviderFundingCount] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210112151037_AlterFundingAllocationAddColumnProviderFundingCount')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210112151037_AlterFundingAllocationAddColumnProviderFundingCount', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210113161453_CreateContractTableLinkToFundingAllocationTableAndAddMissingCreatedDates')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [ContractId] int NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210113161453_CreateContractTableLinkToFundingAllocationTableAndAddMissingCreatedDates')
BEGIN
    CREATE TABLE [FundingAllocation].[Contract] (
        [Id] int NOT NULL IDENTITY,
        [ContractNumber] nvarchar(50) NOT NULL,
        [ContractVersionNumber] int NOT NULL,
        [ContractSubVersionNumber] int NOT NULL,
        [IsCreatedInCrm] bit NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_Contract] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210113161453_CreateContractTableLinkToFundingAllocationTableAndAddMissingCreatedDates')
BEGIN
    CREATE INDEX [IX_FundingAllocation_ContractId] ON [FundingAllocation].[FundingAllocation] ([ContractId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210113161453_CreateContractTableLinkToFundingAllocationTableAndAddMissingCreatedDates')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD CONSTRAINT [FK_FundingAllocation_Contract_ContractId] FOREIGN KEY ([ContractId]) REFERENCES [FundingAllocation].[Contract] ([Id]) ON DELETE NO ACTION;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210113161453_CreateContractTableLinkToFundingAllocationTableAndAddMissingCreatedDates')
BEGIN
    ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] ADD [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE());
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210113161453_CreateContractTableLinkToFundingAllocationTableAndAddMissingCreatedDates')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationProfilePeriod] ADD [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE());
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210113161453_CreateContractTableLinkToFundingAllocationTableAndAddMissingCreatedDates')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210113161453_CreateContractTableLinkToFundingAllocationTableAndAddMissingCreatedDates', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210114143027_ContractTableAddUniqueIndex')
BEGIN
    CREATE UNIQUE INDEX [IX_Contract_ContractNumber_ContractVersionNumber_ContractSubVersionNumber] ON [FundingAllocation].[Contract] ([ContractNumber], [ContractVersionNumber], [ContractSubVersionNumber]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210114143027_ContractTableAddUniqueIndex')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210114143027_ContractTableAddUniqueIndex', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210118101024_FundingAllocationTableRenamePageIndexToPositionInPage')
BEGIN
    EXEC sp_rename N'[FundingAllocation].[FundingAllocation].[PageIndex]', N'PositionInPage', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210118101024_FundingAllocationTableRenamePageIndexToPositionInPage')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210118101024_FundingAllocationTableRenamePageIndexToPositionInPage', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120131554_FundingAllocationTableMakeColumnsNotNull')
BEGIN
    DECLARE @var9 sysname;
    SELECT @var9 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'Value');
    IF @var9 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var9 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] ALTER COLUMN [Value] decimal(18,2) NOT NULL;
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD DEFAULT 0.0 FOR [Value];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120131554_FundingAllocationTableMakeColumnsNotNull')
BEGIN
    DECLARE @var10 sysname;
    SELECT @var10 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'UKPRN');
    IF @var10 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var10 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] ALTER COLUMN [UKPRN] nvarchar(50) NOT NULL;
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD DEFAULT N'' FOR [UKPRN];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120131554_FundingAllocationTableMakeColumnsNotNull')
BEGIN
    DECLARE @var11 sysname;
    SELECT @var11 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'Period');
    IF @var11 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var11 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] ALTER COLUMN [Period] nvarchar(50) NOT NULL;
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD DEFAULT N'' FOR [Period];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120131554_FundingAllocationTableMakeColumnsNotNull')
BEGIN
    DECLARE @var12 sysname;
    SELECT @var12 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'FundingVersion');
    IF @var12 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var12 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] ALTER COLUMN [FundingVersion] nvarchar(50) NOT NULL;
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD DEFAULT N'' FOR [FundingVersion];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120131554_FundingAllocationTableMakeColumnsNotNull')
BEGIN
    DECLARE @var13 sysname;
    SELECT @var13 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'FundingType');
    IF @var13 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var13 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] ALTER COLUMN [FundingType] nvarchar(100) NOT NULL;
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD DEFAULT N'' FOR [FundingType];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120131554_FundingAllocationTableMakeColumnsNotNull')
BEGIN
    DECLARE @var14 sysname;
    SELECT @var14 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'FSPGroup');
    IF @var14 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var14 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] ALTER COLUMN [FSPGroup] nvarchar(100) NOT NULL;
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD DEFAULT N'' FOR [FSPGroup];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120131554_FundingAllocationTableMakeColumnsNotNull')
BEGIN
    DECLARE @var15 sysname;
    SELECT @var15 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'ContractType');
    IF @var15 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var15 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] ALTER COLUMN [ContractType] nvarchar(200) NOT NULL;
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD DEFAULT N'' FOR [ContractType];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120131554_FundingAllocationTableMakeColumnsNotNull')
BEGIN
    DECLARE @var16 sysname;
    SELECT @var16 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'AllocationFundingStream');
    IF @var16 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var16 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] ALTER COLUMN [AllocationFundingStream] nvarchar(50) NOT NULL;
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD DEFAULT N'' FOR [AllocationFundingStream];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120131554_FundingAllocationTableMakeColumnsNotNull')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210120131554_FundingAllocationTableMakeColumnsNotNull', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120141714_CreateFundingAllocationBulkStoredProcedureAndType')
BEGIN

    CREATE TYPE FundingAllocation.FundingAllocationTableType AS TABLE (
    	FundingId nvarchar(200),
    	FundingVersion nvarchar(50),
    	FundingType nvarchar(100),
    	Period nvarchar(50),
    	ContractType nvarchar(200),
    	AllocationFundingStream nvarchar(50),
    	FSPGroup nvarchar(100),
    	UKPRN nvarchar(50),
    	Value decimal(18,2),
    	PositionInPage int,
    	PageNumber int,
    	ProviderFundingCount int)

END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120141714_CreateFundingAllocationBulkStoredProcedureAndType')
BEGIN
    EXEC('
    CREATE PROCEDURE FundingAllocation.InsertFundingAllocations
    	@fundingAllocationsTable FundingAllocation.FundingAllocationTableType READONLY
    AS
    BEGIN
    	INSERT INTO FundingAllocation.FundingAllocation (
    		FundingId,
    		FundingVersion,
    		FundingType,
    		Period,
    		ContractType,
    		AllocationFundingStream,
    		FSPGroup,
    		UKPRN,
    		Value,
    		PositionInPage,
    		PageNumber,
    		ProviderFundingCount)
    	SELECT
    		FundingId,
    		FundingVersion,
    		FundingType,
    		Period,
    		ContractType,
    		AllocationFundingStream,
    		FSPGroup,
    		UKPRN,
    		Value,
    		PositionInPage,
    		PageNumber,
    		ProviderFundingCount
    	FROM
    		@fundingAllocationsTable
    END
    ')
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210120141714_CreateFundingAllocationBulkStoredProcedureAndType')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210120141714_CreateFundingAllocationBulkStoredProcedureAndType', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210121084220_AlterFundingAllocationAddCrmEntityId')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [CrmEntityId] uniqueidentifier NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210121084220_AlterFundingAllocationAddCrmEntityId')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210121084220_AlterFundingAllocationAddCrmEntityId', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210121160135_AddProcessedMessageTable')
BEGIN
    CREATE TABLE [FundingAllocation].[ProcessedMessage] (
        [MessageId] nvarchar(128) NOT NULL,
        [Endpoint] nvarchar(50) NOT NULL,
        [MessageType] nvarchar(100) NOT NULL,
        [BusinessKey] nvarchar(200) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_ProcessedMessage] PRIMARY KEY ([MessageId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210121160135_AddProcessedMessageTable')
BEGIN
    CREATE UNIQUE INDEX [IX_ProcessedMessage_Endpoint_MessageType_BusinessKey] ON [FundingAllocation].[ProcessedMessage] ([Endpoint], [MessageType], [BusinessKey]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210121160135_AddProcessedMessageTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210121160135_AddProcessedMessageTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210126162309_CreateProviderTypeConfigTable')
BEGIN
    CREATE TABLE [FundingAllocation].[ProviderTypeConfig] (
        [Type] nvarchar(50) NOT NULL,
        [Subtype] nvarchar(50) NOT NULL,
        [Category] nvarchar(50) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_ProviderTypeConfig] PRIMARY KEY ([Type], [Subtype])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210126162309_CreateProviderTypeConfigTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210126162309_CreateProviderTypeConfigTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210126162630_CreateAllocationLineConfigTable')
BEGIN
    CREATE TABLE [FundingAllocation].[AllocationLineConfig] (
        [FundingStreamCode] nvarchar(50) NOT NULL,
        [PeriodId] nvarchar(50) NOT NULL,
        [FundingLineCode] nvarchar(50) NOT NULL,
        [ProviderCategory] nvarchar(50) NOT NULL,
        [FspCode] nvarchar(50) NOT NULL,
        [DeliverableCode] int NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_AllocationLineConfig] PRIMARY KEY ([FundingStreamCode], [PeriodId], [FundingLineCode], [ProviderCategory])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210126162630_CreateAllocationLineConfigTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210126162630_CreateAllocationLineConfigTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210127153905_AddTableFundingLineAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationProfilePeriod] DROP CONSTRAINT [FK_FundingAllocationProfilePeriod_ProviderFundingAllocation_ProviderFundingId];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210127153905_AddTableFundingLineAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] ADD [ProviderSubType] nvarchar(50) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210127153905_AddTableFundingLineAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] ADD [ProviderType] nvarchar(50) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210127153905_AddTableFundingLineAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationProfilePeriod] ADD [FundingLineCode] nvarchar(50) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210127153905_AddTableFundingLineAllocation')
BEGIN
    CREATE TABLE [FundingAllocation].[FundingAllocationLine] (
        [ProviderFundingId] nvarchar(100) NOT NULL,
        [FundingLineCode] nvarchar(50) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_FundingAllocationLine] PRIMARY KEY ([ProviderFundingId], [FundingLineCode]),
        CONSTRAINT [FK_FundingAllocationLine_ProviderFundingAllocation_ProviderFundingId] FOREIGN KEY ([ProviderFundingId]) REFERENCES [FundingAllocation].[ProviderFundingAllocation] ([ProviderFundingId]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210127153905_AddTableFundingLineAllocation')
BEGIN
    CREATE INDEX [IX_FundingAllocationProfilePeriod_ProviderFundingId_FundingLineCode] ON [FundingAllocation].[FundingAllocationProfilePeriod] ([ProviderFundingId], [FundingLineCode]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210127153905_AddTableFundingLineAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationProfilePeriod] ADD CONSTRAINT [FK_FundingAllocationProfilePeriod_FundingAllocationLine_ProviderFundingId_FundingLineCode] FOREIGN KEY ([ProviderFundingId], [FundingLineCode]) REFERENCES [FundingAllocation].[FundingAllocationLine] ([ProviderFundingId], [FundingLineCode]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210127153905_AddTableFundingLineAllocation')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210127153905_AddTableFundingLineAllocation', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210201144423_CreateFspDeliverable')
BEGIN
    CREATE TABLE [FundingAllocation].[FspDeliverable] (
        [FspCode] nvarchar(50) NOT NULL,
        [DeliverableCode] int NOT NULL,
        [DeliverableName] nvarchar(100) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_FspDeliverable] PRIMARY KEY ([FspCode], [DeliverableCode])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210201144423_CreateFspDeliverable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210201144423_CreateFspDeliverable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210202094742_CreateFkToFspDeliverable')
BEGIN
    CREATE INDEX [IX_AllocationLineConfig_FspCode_DeliverableCode] ON [FundingAllocation].[AllocationLineConfig] ([FspCode], [DeliverableCode]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210202094742_CreateFkToFspDeliverable')
BEGIN
    ALTER TABLE [FundingAllocation].[AllocationLineConfig] ADD CONSTRAINT [FK_AllocationLineConfig_FspDeliverable_FspCode_DeliverableCode] FOREIGN KEY ([FspCode], [DeliverableCode]) REFERENCES [FundingAllocation].[FspDeliverable] ([FspCode], [DeliverableCode]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210202094742_CreateFkToFspDeliverable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210202094742_CreateFkToFspDeliverable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210203135910_CorrectFundingAllocationProfilePeriodPrimaryKey')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationProfilePeriod] DROP CONSTRAINT [PK_FundingAllocationProfilePeriod];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210203135910_CorrectFundingAllocationProfilePeriodPrimaryKey')
BEGIN
    DROP INDEX [IX_FundingAllocationProfilePeriod_ProviderFundingId_FundingLineCode] ON [FundingAllocation].[FundingAllocationProfilePeriod];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210203135910_CorrectFundingAllocationProfilePeriodPrimaryKey')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationProfilePeriod] ADD CONSTRAINT [PK_FundingAllocationProfilePeriod] PRIMARY KEY ([ProviderFundingId], [FundingLineCode], [Period]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210203135910_CorrectFundingAllocationProfilePeriodPrimaryKey')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210203135910_CorrectFundingAllocationProfilePeriodPrimaryKey', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210204142158_RenameTableFspDeliverableToFspDeliverableConfig')
BEGIN
    ALTER TABLE [FundingAllocation].[AllocationLineConfig] DROP CONSTRAINT [FK_AllocationLineConfig_FspDeliverable_FspCode_DeliverableCode];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210204142158_RenameTableFspDeliverableToFspDeliverableConfig')
BEGIN
    DROP TABLE [FundingAllocation].[FspDeliverable];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210204142158_RenameTableFspDeliverableToFspDeliverableConfig')
BEGIN
    CREATE TABLE [FundingAllocation].[FspDeliverableConfig] (
        [FspCode] nvarchar(50) NOT NULL,
        [DeliverableCode] int NOT NULL,
        [DeliverableName] nvarchar(100) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_FspDeliverableConfig] PRIMARY KEY ([FspCode], [DeliverableCode])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210204142158_RenameTableFspDeliverableToFspDeliverableConfig')
BEGIN
    ALTER TABLE [FundingAllocation].[AllocationLineConfig] ADD CONSTRAINT [FK_AllocationLineConfig_FspDeliverableConfig_FspCode_DeliverableCode] FOREIGN KEY ([FspCode], [DeliverableCode]) REFERENCES [FundingAllocation].[FspDeliverableConfig] ([FspCode], [DeliverableCode]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210204142158_RenameTableFspDeliverableToFspDeliverableConfig')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210204142158_RenameTableFspDeliverableToFspDeliverableConfig', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210211153346_CreateAllocationFundingStreamConfigTable')
BEGIN
    CREATE TABLE [FundingAllocation].[AllocationFundingStreamConfig] (
        [AllocationFundingStreamCode] nvarchar(50) NOT NULL,
        [AllocationPeriodId] nvarchar(50) NOT NULL,
        [FundingTypeCode] nvarchar(50) NOT NULL,
        [FundingPeriodCode] nvarchar(50) NOT NULL,
        [FSPGroupCode] nvarchar(50) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_AllocationFundingStreamConfig] PRIMARY KEY ([AllocationFundingStreamCode], [AllocationPeriodId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210211153346_CreateAllocationFundingStreamConfigTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210211153346_CreateAllocationFundingStreamConfigTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210211153647_CreateCfsCodesToContractTypeConfigTable')
BEGIN
    CREATE TABLE [FundingAllocation].[CfsCodesToContractTypeConfig] (
        [FundingTypeCode] nvarchar(50) NOT NULL,
        [FundingPeriodCode] nvarchar(50) NOT NULL,
        [ProviderCategory] nvarchar(50) NOT NULL,
        [ContractType] nvarchar(100) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_CfsCodesToContractTypeConfig] PRIMARY KEY ([FundingTypeCode], [FundingPeriodCode], [ProviderCategory])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210211153647_CreateCfsCodesToContractTypeConfigTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210211153647_CreateCfsCodesToContractTypeConfigTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210216102400_DropObsoleteFundingAllocationColumns')
BEGIN
    DECLARE @var17 sysname;
    SELECT @var17 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'ContractType');
    IF @var17 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var17 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [ContractType];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210216102400_DropObsoleteFundingAllocationColumns')
BEGIN
    DECLARE @var18 sysname;
    SELECT @var18 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'FSPGroup');
    IF @var18 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var18 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [FSPGroup];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210216102400_DropObsoleteFundingAllocationColumns')
BEGIN
    DECLARE @var19 sysname;
    SELECT @var19 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[FundingAllocation]') AND [c].[name] = N'FundingType');
    IF @var19 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [' + @var19 + '];');
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP COLUMN [FundingType];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210216102400_DropObsoleteFundingAllocationColumns')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210216102400_DropObsoleteFundingAllocationColumns', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210216110351_AlterFundingAllocationBulkStoredProcedureAndType')
BEGIN
    DROP PROCEDURE FundingAllocation.InsertFundingAllocations
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210216110351_AlterFundingAllocationBulkStoredProcedureAndType')
BEGIN
    DROP TYPE FundingAllocation.FundingAllocationTableType
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210216110351_AlterFundingAllocationBulkStoredProcedureAndType')
BEGIN

    CREATE TYPE FundingAllocation.FundingAllocationTableType AS TABLE (
    	FundingId nvarchar(200),
    	FundingVersion nvarchar(50),
    	Period nvarchar(50),
    	AllocationFundingStream nvarchar(50),
    	UKPRN nvarchar(50),
    	Value decimal(18,2),
    	PositionInPage int,
    	PageNumber int,
    	ProviderFundingCount int)

END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210216110351_AlterFundingAllocationBulkStoredProcedureAndType')
BEGIN
    EXEC('
    CREATE PROCEDURE FundingAllocation.InsertFundingAllocations
    	@fundingAllocationsTable FundingAllocation.FundingAllocationTableType READONLY
    AS
    BEGIN
    	INSERT INTO FundingAllocation.FundingAllocation (
    		FundingId,
    		FundingVersion,
    		Period,
    		AllocationFundingStream,
    		UKPRN,
    		Value,
    		PositionInPage,
    		PageNumber,
    		ProviderFundingCount)
    	SELECT
    		FundingId,
    		FundingVersion,
    		Period,
    		AllocationFundingStream,
    		UKPRN,
    		Value,
    		PositionInPage,
    		PageNumber,
    		ProviderFundingCount
    	FROM
    		@fundingAllocationsTable
    END
    ')
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210216110351_AlterFundingAllocationBulkStoredProcedureAndType')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210216110351_AlterFundingAllocationBulkStoredProcedureAndType', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210217150504_AddFundingTypeConfigTable')
BEGIN
    CREATE TABLE [FundingAllocation].[FundingTypeConfig] (
        [FundingTypeCode] nvarchar(50) NOT NULL,
        [ContractReferencePrefix] nvarchar(50) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_FundingTypeConfig] PRIMARY KEY ([FundingTypeCode])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210217150504_AddFundingTypeConfigTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210217150504_AddFundingTypeConfigTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210217150846_AddFundingStreamPeriodConfigTable')
BEGIN
    CREATE TABLE [FundingAllocation].[FundingStreamPeriodConfig] (
        [FundingStreamPeriodCode] nvarchar(50) NOT NULL,
        [FundingStreamCode] nvarchar(50) NOT NULL,
        [AllocationReferencePrefix] nvarchar(50) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_FundingStreamPeriodConfig] PRIMARY KEY ([FundingStreamPeriodCode])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210217150846_AddFundingStreamPeriodConfigTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210217150846_AddFundingStreamPeriodConfigTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210217151141_AddDisplayOrderToFspDeliverableConfigTable')
BEGIN
    ALTER TABLE [FundingAllocation].[FspDeliverableConfig] ADD [DisplayOrder] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210217151141_AddDisplayOrderToFspDeliverableConfigTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210217151141_AddDisplayOrderToFspDeliverableConfigTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210222162550_AlterFundingAllocationPageControlDropPageNumberIndex')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationPageControl] DROP CONSTRAINT [AK_FundingAllocationPageControl_PageNumber];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210222162550_AlterFundingAllocationPageControlDropPageNumberIndex')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210222162550_AlterFundingAllocationPageControlDropPageNumberIndex', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210226110241_CreateReleaseGroupTable')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [FK_FundingAllocation_Contract_ContractId];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210226110241_CreateReleaseGroupTable')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [ReleaseGroupId] int NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210226110241_CreateReleaseGroupTable')
BEGIN
    CREATE TABLE [FundingAllocation].[ReleaseGroup] (
        [Id] int NOT NULL IDENTITY,
        [FundingTypeCode] nvarchar(50) NOT NULL,
        [FundingPeriodCode] nvarchar(50) NOT NULL,
        [FSPGroupCode] nvarchar(50) NOT NULL,
        [ContractType] nvarchar(100) NOT NULL,
        [CrmEntityId] uniqueidentifier NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_ReleaseGroup] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210226110241_CreateReleaseGroupTable')
BEGIN
    CREATE INDEX [IX_FundingAllocation_ReleaseGroupId] ON [FundingAllocation].[FundingAllocation] ([ReleaseGroupId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210226110241_CreateReleaseGroupTable')
BEGIN
    CREATE UNIQUE INDEX [IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_CrmEntityId] ON [FundingAllocation].[ReleaseGroup] ([FundingTypeCode], [FundingPeriodCode], [FSPGroupCode], [ContractType], [CrmEntityId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210226110241_CreateReleaseGroupTable')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD CONSTRAINT [FK_FundingAllocation_Contract_ContractId] FOREIGN KEY ([ContractId]) REFERENCES [FundingAllocation].[Contract] ([Id]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210226110241_CreateReleaseGroupTable')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD CONSTRAINT [FK_FundingAllocation_ReleaseGroup_ReleaseGroupId] FOREIGN KEY ([ReleaseGroupId]) REFERENCES [FundingAllocation].[ReleaseGroup] ([Id]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210226110241_CreateReleaseGroupTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210226110241_CreateReleaseGroupTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210301155530_CreateSequenceReleaseGroup')
BEGIN
    CREATE SEQUENCE FundingAllocation.ReleaseGroup_seq  
                START WITH 1
                INCREMENT BY 1; 
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210301155530_CreateSequenceReleaseGroup')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210301155530_CreateSequenceReleaseGroup', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210302140510_AmendSequenceReleaseGroup')
BEGIN
    ALTER SEQUENCE [FundingAllocation].[ReleaseGroup_seq]
                RESTART WITH 100000  
                INCREMENT BY 1; 
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210302140510_AmendSequenceReleaseGroup')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210302140510_AmendSequenceReleaseGroup', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210302160226_ReleaseGroupTableAddStatusAndReleaseGroupName')
BEGIN
    ALTER TABLE [FundingAllocation].[ReleaseGroup] ADD [ReleaseGroupName] nvarchar(50) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210302160226_ReleaseGroupTableAddStatusAndReleaseGroupName')
BEGIN
    ALTER TABLE [FundingAllocation].[ReleaseGroup] ADD [Status] nvarchar(50) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210302160226_ReleaseGroupTableAddStatusAndReleaseGroupName')
BEGIN
    CREATE UNIQUE INDEX [IX_ReleaseGroup_ReleaseGroupName] ON [FundingAllocation].[ReleaseGroup] ([ReleaseGroupName]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210302160226_ReleaseGroupTableAddStatusAndReleaseGroupName')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210302160226_ReleaseGroupTableAddStatusAndReleaseGroupName', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210304093703_ChangeUniqueIndexOnReleaseGroupAddReleasedDate')
BEGIN
    DROP INDEX [IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_CrmEntityId] ON [FundingAllocation].[ReleaseGroup];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210304093703_ChangeUniqueIndexOnReleaseGroupAddReleasedDate')
BEGIN
    ALTER TABLE [FundingAllocation].[ReleaseGroup] ADD [ReleasedDate] datetime2 NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210304093703_ChangeUniqueIndexOnReleaseGroupAddReleasedDate')
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX [IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_ReleasedDate]
                ON[FundingAllocation].[ReleaseGroup]
                ([FundingTypeCode] ASC,
                 [FundingPeriodCode] ASC,
                 [FSPGroupCode] ASC,
                 [ContractType] ASC,
                 [ReleasedDate] ASC) WHERE([ReleasedDate] IS NULL); 
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210304093703_ChangeUniqueIndexOnReleaseGroupAddReleasedDate')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210304093703_ChangeUniqueIndexOnReleaseGroupAddReleasedDate', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210310084515_ChangeUniqueIndexOnReleaseGroupAddStatus')
BEGIN
    DROP INDEX [IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_ReleasedDate]
                    ON [FundingAllocation].[ReleaseGroup]
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210310084515_ChangeUniqueIndexOnReleaseGroupAddStatus')
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_Status_ReleasedDate] ON [FundingAllocation].[ReleaseGroup] ([FundingTypeCode], [FundingPeriodCode], [FSPGroupCode], [ContractType], [Status], [ReleasedDate]) WHERE [ReleasedDate] IS NULL');
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210310084515_ChangeUniqueIndexOnReleaseGroupAddStatus')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210310084515_ChangeUniqueIndexOnReleaseGroupAddStatus', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317084011_FeedReadTableCreate')
BEGIN
    CREATE TABLE [FundingAllocation].[FeedRead] (
        [ReadId] int NOT NULL IDENTITY,
        [ReadCompletedDate] datetime2 NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_FeedRead] PRIMARY KEY ([ReadId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317084011_FeedReadTableCreate')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210317084011_FeedReadTableCreate', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317113207_FeedReadFkFromFundingAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [ReadId] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317113207_FeedReadFkFromFundingAllocation')
BEGIN
    CREATE INDEX [IX_FundingAllocation_ReadId] ON [FundingAllocation].[FundingAllocation] ([ReadId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317113207_FeedReadFkFromFundingAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD CONSTRAINT [FK_FundingAllocation_FeedRead_ReadId] FOREIGN KEY ([ReadId]) REFERENCES [FundingAllocation].[FeedRead] ([ReadId]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317113207_FeedReadFkFromFundingAllocation')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210317113207_FeedReadFkFromFundingAllocation', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317135029_AlterStoredProc')
BEGIN
    DROP PROCEDURE FundingAllocation.InsertFundingAllocations
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317135029_AlterStoredProc')
BEGIN
    DROP TYPE FundingAllocation.FundingAllocationTableType
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317135029_AlterStoredProc')
BEGIN

                        CREATE TYPE FundingAllocation.FundingAllocationTableType AS TABLE (
    	                    FundingId nvarchar(200),
    	                    FundingVersion nvarchar(50),
    	                    Period nvarchar(50),
    	                    AllocationFundingStream nvarchar(50),
    	                    UKPRN nvarchar(50),
    	                    Value decimal(18,2),
    	                    PositionInPage int,
    	                    PageNumber int,
    	                    ProviderFundingCount int,
                            ReadId int)
                        
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317135029_AlterStoredProc')
BEGIN
    EXEC('
                        CREATE PROCEDURE FundingAllocation.InsertFundingAllocations
    	                    @fundingAllocationsTable FundingAllocation.FundingAllocationTableType READONLY
                        AS
                        BEGIN
    	                    INSERT INTO FundingAllocation.FundingAllocation (
    		            FundingId,
    		            FundingVersion,
    		            Period,
    		            AllocationFundingStream,
    		            UKPRN,
    		            Value,
    		            PositionInPage,
    		            PageNumber,
    		            ProviderFundingCount,
                        ReadId)
    	            SELECT
    		            FundingId,
    		            FundingVersion,
    		            Period,
    		            AllocationFundingStream,
    		            UKPRN,
    		            Value,
    		            PositionInPage,
    		            PageNumber,
    		            ProviderFundingCount,
                        ReadId
    	            FROM
    		                    @fundingAllocationsTable
                        END
                        ')
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210317135029_AlterStoredProc')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210317135029_AlterStoredProc', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210322131356_DropRead_seqSequence')
BEGIN
    DROP SEQUENCE FundingAllocation.Read_seq 
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210322131356_DropRead_seqSequence')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210322131356_DropRead_seqSequence', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210426102530_AddStatusColToFundingAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [Status] nvarchar(50) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210426102530_AddStatusColToFundingAllocation')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210426102530_AddStatusColToFundingAllocation', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210426134647_AddFundingAllocationNameColToFundingAllocation')
BEGIN
    Delete from [FundingAllocation].[FundingAllocation]
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210426134647_AddFundingAllocationNameColToFundingAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [FundingAllocationName] nvarchar(200) NOT NULL DEFAULT N'';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210426134647_AddFundingAllocationNameColToFundingAllocation')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210426134647_AddFundingAllocationNameColToFundingAllocation', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210427084406_AddFundingAllocationNameIndex')
BEGIN
    CREATE INDEX [IX_FundingAllocation_FundingAllocationName] ON [FundingAllocation].[FundingAllocation] ([FundingAllocationName]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210427084406_AddFundingAllocationNameIndex')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210427084406_AddFundingAllocationNameIndex', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210428122450_AlterStoredProcFundingAllocationName')
BEGIN
    DROP PROCEDURE FundingAllocation.InsertFundingAllocations
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210428122450_AlterStoredProcFundingAllocationName')
BEGIN
    DROP TYPE FundingAllocation.FundingAllocationTableType
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210428122450_AlterStoredProcFundingAllocationName')
BEGIN

                    CREATE TYPE FundingAllocation.FundingAllocationTableType AS TABLE (
    	                FundingId nvarchar(200),
    	                FundingVersion nvarchar(50),
    	                Period nvarchar(50),
    	                AllocationFundingStream nvarchar(50),
    	                UKPRN nvarchar(50),
    	                Value decimal(18,2),
    	                PositionInPage int,
    	                PageNumber int,
    	                ProviderFundingCount int,
                        ReadId int,
                        FundingAllocationName nvarchar(200))
                    
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210428122450_AlterStoredProcFundingAllocationName')
BEGIN
    EXEC('
                        CREATE PROCEDURE FundingAllocation.InsertFundingAllocations
    	                    @fundingAllocationsTable FundingAllocation.FundingAllocationTableType READONLY
                        AS
                        BEGIN
    	                    INSERT INTO FundingAllocation.FundingAllocation (
    		            FundingId,
    		            FundingVersion,
    		            Period,
    		            AllocationFundingStream,
    		            UKPRN,
    		            Value,
    		            PositionInPage,
    		            PageNumber,
    		            ProviderFundingCount,
                        ReadId,
                        FundingAllocationName)
    	            SELECT
    		            FundingId,
    		            FundingVersion,
    		            Period,
    		            AllocationFundingStream,
    		            UKPRN,
    		            Value,
    		            PositionInPage,
    		            PageNumber,
    		            ProviderFundingCount,
                        ReadId,
                        FundingAllocationName
    	            FROM
    		                    @fundingAllocationsTable
                        END
                        ')
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210428122450_AlterStoredProcFundingAllocationName')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210428122450_AlterStoredProcFundingAllocationName', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210430144241_AddSubStatusColToFundingAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [SubStatus] nvarchar(50) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210430144241_AddSubStatusColToFundingAllocation')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210430144241_AddSubStatusColToFundingAllocation', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210504123336_AddedStatusSubStatusConfigTable')
BEGIN
    CREATE TABLE [FundingAllocation].[StatusSubStatusConfig] (
        [Status] nvarchar(50) NOT NULL,
        [SubStatus] nvarchar(50) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_StatusSubStatusConfig] PRIMARY KEY ([Status], [SubStatus])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210504123336_AddedStatusSubStatusConfigTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210504123336_AddedStatusSubStatusConfigTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210505080107_AddStatusSubstatusIndexToFundingAllocation')
BEGIN
    CREATE INDEX [IX_FundingAllocation_Status_SubStatus] ON [FundingAllocation].[FundingAllocation] ([Status], [SubStatus]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210505080107_AddStatusSubstatusIndexToFundingAllocation')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210505080107_AddStatusSubstatusIndexToFundingAllocation', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210506135033_AddedFkeyFromFundingAllocationsToStatusSubStatusConfig')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD CONSTRAINT [FK_FundingAllocation_StatusSubStatusConfig_Status_SubStatus] FOREIGN KEY ([Status], [SubStatus]) REFERENCES [FundingAllocation].[StatusSubStatusConfig] ([Status], [SubStatus]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210506135033_AddedFkeyFromFundingAllocationsToStatusSubStatusConfig')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210506135033_AddedFkeyFromFundingAllocationsToStatusSubStatusConfig', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210511151419_AddedProviderCategoryException')
BEGIN
    CREATE TABLE [FundingAllocation].[ProviderCategoryException] (
        [FundingTypeCode] nvarchar(50) NOT NULL,
        [FundingPeriodCode] nvarchar(50) NOT NULL,
        [UKPRN] nvarchar(50) NOT NULL,
        [Category] nvarchar(50) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE())
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210511151419_AddedProviderCategoryException')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210511151419_AddedProviderCategoryException', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210513105845_AddedProviderCategoryExceptionPrimaryKey')
BEGIN
    ALTER TABLE [FundingAllocation].[ProviderCategoryException] ADD CONSTRAINT [PK_ProviderCategoryException] PRIMARY KEY ([FundingTypeCode], [FundingPeriodCode], [UKPRN]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210513105845_AddedProviderCategoryExceptionPrimaryKey')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210513105845_AddedProviderCategoryExceptionPrimaryKey', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210518152908_AddedParkingInfoTable')
BEGIN
    CREATE TABLE [FundingAllocation].[ParkingInfo] (
        [FundingAllocationId] nvarchar(200) NOT NULL,
        [LastParked] datetime NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_ParkingInfo] PRIMARY KEY ([FundingAllocationId]),
        CONSTRAINT [FK_ParkingInfo_FundingAllocation_FundingAllocationId] FOREIGN KEY ([FundingAllocationId]) REFERENCES [FundingAllocation].[FundingAllocation] ([FundingId]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210518152908_AddedParkingInfoTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210518152908_AddedParkingInfoTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210528100927_AmendedFeedReadDates')
BEGIN
    EXEC sp_rename N'[FundingAllocation].[FeedRead].[ReadCompletedDate]', N'CfsReadCompletedDate', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210528100927_AmendedFeedReadDates')
BEGIN
    ALTER TABLE [FundingAllocation].[FeedRead] ADD [JobCompletedDate] datetime NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210528100927_AmendedFeedReadDates')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210528100927_AmendedFeedReadDates', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210528144107_DropFeedReadData')
BEGIN
    delete from [FundingAllocation].[FeedRead]
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210528144107_DropFeedReadData')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210528144107_DropFeedReadData', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationLine] DROP CONSTRAINT [FK_FundingAllocationLine_ProviderFundingAllocation_ProviderFundingId];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] DROP CONSTRAINT [PK_ProviderFundingAllocation];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    DECLARE @var20 sysname;
    SELECT @var20 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[ProviderFundingAllocation]') AND [c].[name] = N'DeliveryUkprn');
    IF @var20 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] DROP CONSTRAINT [' + @var20 + '];');
    ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] DROP COLUMN [DeliveryUkprn];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    DECLARE @var21 sysname;
    SELECT @var21 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[ProviderFundingAllocation]') AND [c].[name] = N'ProviderSubType');
    IF @var21 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] DROP CONSTRAINT [' + @var21 + '];');
    ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] DROP COLUMN [ProviderSubType];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    DECLARE @var22 sysname;
    SELECT @var22 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[ProviderFundingAllocation]') AND [c].[name] = N'ProviderType');
    IF @var22 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] DROP CONSTRAINT [' + @var22 + '];');
    ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] DROP COLUMN [ProviderType];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] ADD CONSTRAINT [PK_ProviderFundingAllocation] PRIMARY KEY ([ProviderFundingId], [FundingId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    CREATE TABLE [FundingAllocation].[ProviderFunding] (
        [ProviderFundingId] nvarchar(100) NOT NULL,
        [DeliveryUkprn] int NOT NULL,
        [ProviderType] nvarchar(50) NOT NULL,
        [ProviderSubType] nvarchar(50) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_ProviderFunding] PRIMARY KEY ([ProviderFundingId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationLine] ADD CONSTRAINT [FK_FundingAllocationLine_ProviderFunding_ProviderFundingId] FOREIGN KEY ([ProviderFundingId]) REFERENCES [FundingAllocation].[ProviderFunding] ([ProviderFundingId]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    ALTER TABLE [FundingAllocation].[ProviderFundingAllocation] ADD CONSTRAINT [FK_ProviderFundingAllocation_ProviderFunding_ProviderFundingId] FOREIGN KEY ([ProviderFundingId]) REFERENCES [FundingAllocation].[ProviderFunding] ([ProviderFundingId]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210609130903_CreateProviderFundingTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210609130903_CreateProviderFundingTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210617063954_FundingStreamPeriodConfigStartEndDates')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingStreamPeriodConfig] ADD [StartDate] datetime NOT NULL DEFAULT '2021-01-01T00:00:00.000';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210617063954_FundingStreamPeriodConfigStartEndDates')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingStreamPeriodConfig] ADD [EndDate] datetime NOT NULL DEFAULT '2021-01-01T00:00:00.000';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210617063954_FundingStreamPeriodConfigStartEndDates')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210617063954_FundingStreamPeriodConfigStartEndDates', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210629140626_CreateFundingTypeFundingPeriodConfigTable')
BEGIN
    CREATE TABLE [FundingAllocation].[FundingTypeFundingPeriodConfig] (
        [FundingTypeCode] nvarchar(50) NOT NULL,
        [FundingPeriodName] nvarchar(50) NOT NULL,
        [FtpGroupCode] nvarchar(50) NULL,
        [PrecedingFtpFundingType] nvarchar(50) NULL,
        [PrecedingFtpFundingPeriod] nvarchar(50) NULL,
        [IncludeAllContractsOnSummaryOfFunding] bit NOT NULL,
        [AllowNewAmendment] bit NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_FundingTypeFundingPeriodConfig] PRIMARY KEY ([FundingTypeCode], [FundingPeriodName])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210629140626_CreateFundingTypeFundingPeriodConfigTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210629140626_CreateFundingTypeFundingPeriodConfigTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210630081719_FundingTypeFundingPeriodConfigRenameFundingPeriodNameToFundingPeriod')
BEGIN
    EXEC sp_rename N'[FundingAllocation].[FundingTypeFundingPeriodConfig].[FundingPeriodName]', N'FundingPeriod', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210630081719_FundingTypeFundingPeriodConfigRenameFundingPeriodNameToFundingPeriod')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210630081719_FundingTypeFundingPeriodConfigRenameFundingPeriodNameToFundingPeriod', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210705151512_RemoveForeignKeyBetweenFeedReadAndFundingAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] DROP CONSTRAINT [FK_FundingAllocation_FeedRead_ReadId];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210705151512_RemoveForeignKeyBetweenFeedReadAndFundingAllocation')
BEGIN
    DROP INDEX [IX_FundingAllocation_ReadId] ON [FundingAllocation].[FundingAllocation];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210705151512_RemoveForeignKeyBetweenFeedReadAndFundingAllocation')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210705151512_RemoveForeignKeyBetweenFeedReadAndFundingAllocation', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210705155052_AddForeignKeysBetweenFeedAndReadFundingAllocationPageControlAndFundingAllocation')
BEGIN
    CREATE INDEX [IX_FundingAllocation_ReadId_PageNumber] ON [FundingAllocation].[FundingAllocation] ([ReadId], [PageNumber]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210705155052_AddForeignKeysBetweenFeedAndReadFundingAllocationPageControlAndFundingAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD CONSTRAINT [FK_FundingAllocation_FundingAllocationPageControl_ReadId_PageNumber] FOREIGN KEY ([ReadId], [PageNumber]) REFERENCES [FundingAllocation].[FundingAllocationPageControl] ([ReadId], [PageNumber]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210705155052_AddForeignKeysBetweenFeedAndReadFundingAllocationPageControlAndFundingAllocation')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationPageControl] ADD CONSTRAINT [FK_FundingAllocationPageControl_FeedRead_ReadId] FOREIGN KEY ([ReadId]) REFERENCES [FundingAllocation].[FeedRead] ([ReadId]) ON DELETE CASCADE;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210705155052_AddForeignKeysBetweenFeedAndReadFundingAllocationPageControlAndFundingAllocation')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210705155052_AddForeignKeysBetweenFeedAndReadFundingAllocationPageControlAndFundingAllocation', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210723090718_AddAllAmendmentsRequireSigningColToFundingTypeFundingPeriodConfig')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingTypeFundingPeriodConfig] ADD [AllAmendmentsRequireSigning] bit NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210723090718_AddAllAmendmentsRequireSigningColToFundingTypeFundingPeriodConfig')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210723090718_AddAllAmendmentsRequireSigningColToFundingTypeFundingPeriodConfig', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210901135103_CreateBulkUploadStatusTable')
BEGIN
    CREATE TABLE [FundingAllocation].[BulkUploadStatus] (
        [BulkUploadStatusId] int NOT NULL IDENTITY,
        [FundingTypeCode] nvarchar(100) NOT NULL,
        [FundingPeriodName] nvarchar(100) NOT NULL,
        [Status] nvarchar(100) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_BulkUploadStatus] PRIMARY KEY ([BulkUploadStatusId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210901135103_CreateBulkUploadStatusTable')
BEGIN
    CREATE UNIQUE INDEX [IX_BulkUploadStatus_FundingTypeCode_FundingPeriodName_Status] ON [FundingAllocation].[BulkUploadStatus] ([FundingTypeCode], [FundingPeriodName], [Status]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210901135103_CreateBulkUploadStatusTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210901135103_CreateBulkUploadStatusTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210906073411_CreateReleaseGroupGroup')
BEGIN
    CREATE TABLE [FundingAllocation].[ReleaseGroupGroup] (
        [GroupId] int NOT NULL,
        [FundingTypeCode] nvarchar(50) NOT NULL,
        [FundingPeriodCode] nvarchar(50) NOT NULL,
        [ReleaseGroupName] nvarchar(50) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_ReleaseGroupGroup] PRIMARY KEY ([GroupId], [FundingTypeCode], [FundingPeriodCode])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210906073411_CreateReleaseGroupGroup')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210906073411_CreateReleaseGroupGroup', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210906074928_CreateReleaseGroupGroupSeq')
BEGIN
    CREATE SEQUENCE FundingAllocation.ReleaseGroupGroupId_seq  
                START WITH 1
                INCREMENT BY 1; 
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210906074928_CreateReleaseGroupGroupSeq')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210906074928_CreateReleaseGroupGroupSeq', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210907063119_AlterReleaseGroupGroupTable')
BEGIN
    ALTER TABLE [FundingAllocation].[ReleaseGroupGroup] DROP CONSTRAINT [PK_ReleaseGroupGroup];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210907063119_AlterReleaseGroupGroupTable')
BEGIN
    DECLARE @var23 sysname;
    SELECT @var23 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[ReleaseGroupGroup]') AND [c].[name] = N'FundingTypeCode');
    IF @var23 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[ReleaseGroupGroup] DROP CONSTRAINT [' + @var23 + '];');
    ALTER TABLE [FundingAllocation].[ReleaseGroupGroup] DROP COLUMN [FundingTypeCode];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210907063119_AlterReleaseGroupGroupTable')
BEGIN
    DECLARE @var24 sysname;
    SELECT @var24 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[ReleaseGroupGroup]') AND [c].[name] = N'FundingPeriodCode');
    IF @var24 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[ReleaseGroupGroup] DROP CONSTRAINT [' + @var24 + '];');
    ALTER TABLE [FundingAllocation].[ReleaseGroupGroup] DROP COLUMN [FundingPeriodCode];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210907063119_AlterReleaseGroupGroupTable')
BEGIN
    DECLARE @var25 sysname;
    SELECT @var25 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[ReleaseGroupGroup]') AND [c].[name] = N'ReleaseGroupName');
    IF @var25 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[ReleaseGroupGroup] DROP CONSTRAINT [' + @var25 + '];');
    ALTER TABLE [FundingAllocation].[ReleaseGroupGroup] DROP COLUMN [ReleaseGroupName];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210907063119_AlterReleaseGroupGroupTable')
BEGIN
    EXEC sp_rename N'[FundingAllocation].[ReleaseGroupGroup].[GroupId]', N'ReleaseGroupId', N'COLUMN';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210907063119_AlterReleaseGroupGroupTable')
BEGIN
    ALTER TABLE [FundingAllocation].[ReleaseGroupGroup] ADD [ReleaseGroupGroupId] int NOT NULL DEFAULT 0;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210907063119_AlterReleaseGroupGroupTable')
BEGIN
    ALTER TABLE [FundingAllocation].[ReleaseGroupGroup] ADD CONSTRAINT [PK_ReleaseGroupGroup] PRIMARY KEY ([ReleaseGroupGroupId], [ReleaseGroupId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210907063119_AlterReleaseGroupGroupTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210907063119_AlterReleaseGroupGroupTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210908204738_AlterBulkUploadStatusTable')
BEGIN
    DROP TABLE [FundingAllocation].[BulkUploadStatus];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210908204738_AlterBulkUploadStatusTable')
BEGIN
    CREATE TABLE [FundingAllocation].[BulkUploadStatus] (
        [BulkUploadBatchId] UniqueIdentifier NOT NULL,
        [FundingTypeCode] nvarchar(100) NOT NULL,
        [FundingPeriodName] nvarchar(100) NOT NULL,
        [Status] nvarchar(100) NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_BulkUploadStatus] PRIMARY KEY ([BulkUploadBatchId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210908204738_AlterBulkUploadStatusTable')
BEGIN
    CREATE INDEX [IX_BulkUploadStatus_FundingTypeCode_FundingPeriodName] ON [FundingAllocation].[BulkUploadStatus] ([FundingTypeCode], [FundingPeriodName]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210908204738_AlterBulkUploadStatusTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210908204738_AlterBulkUploadStatusTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210915082603_RenameTableToParkingAndDiscardedInfo')
BEGIN
    EXEC sp_rename 'FundingAllocation.ParkingInfo', 'ParkingAndDiscardedInfo'
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210915082603_RenameTableToParkingAndDiscardedInfo')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210915082603_RenameTableToParkingAndDiscardedInfo', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210915123303_AddedNewColumnLastDiscarded')
BEGIN
    DECLARE @var26 sysname;
    SELECT @var26 = [d].[name]
    FROM [sys].[default_constraints] [d]
    INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
    WHERE ([d].[parent_object_id] = OBJECT_ID(N'[FundingAllocation].[ParkingAndDiscardedInfo]') AND [c].[name] = N'LastParked');
    IF @var26 IS NOT NULL EXEC(N'ALTER TABLE [FundingAllocation].[ParkingAndDiscardedInfo] DROP CONSTRAINT [' + @var26 + '];');
    ALTER TABLE [FundingAllocation].[ParkingAndDiscardedInfo] ALTER COLUMN [LastParked] datetime NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210915123303_AddedNewColumnLastDiscarded')
BEGIN
    ALTER TABLE [FundingAllocation].[ParkingAndDiscardedInfo] ADD [LastDiscarded] datetime NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20210915123303_AddedNewColumnLastDiscarded')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20210915123303_AddedNewColumnLastDiscarded', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211018105423_AddRelationshipToFundingAllocationColToContract')
BEGIN
    DROP INDEX [IX_Contract_ContractNumber_ContractVersionNumber_ContractSubVersionNumber] ON [FundingAllocation].[Contract];
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211018105423_AddRelationshipToFundingAllocationColToContract')
BEGIN
    ALTER TABLE [FundingAllocation].[Contract] ADD [RelationshipToFundingAllocation] nvarchar(20) NOT NULL DEFAULT N'Created';
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211018105423_AddRelationshipToFundingAllocationColToContract')
BEGIN
    CREATE UNIQUE INDEX [IX_Contract_ContractNumber_ContractVersionNumber_ContractSubVersionNumber_RelationshipToFundingAllocation] ON [FundingAllocation].[Contract] ([ContractNumber], [ContractVersionNumber], [ContractSubVersionNumber], [RelationshipToFundingAllocation]);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211018105423_AddRelationshipToFundingAllocationColToContract')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20211018105423_AddRelationshipToFundingAllocationColToContract', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211118103053_AddIsPublishedColToFundingAllocationTable')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocation] ADD [IsPublished] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211118103053_AddIsPublishedColToFundingAllocationTable')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20211118103053_AddIsPublishedColToFundingAllocationTable', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211124075056_IsOfNoInterestColumn')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingAllocationLine] ADD [IsOfNoInterest] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211124075056_IsOfNoInterestColumn')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20211124075056_IsOfNoInterestColumn', N'5.0.1');
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20230824081539_AddContractExpireColumn')
BEGIN
    ALTER TABLE [FundingAllocation].[FundingTypeFundingPeriodConfig] ADD [ContractExpiryDate] datetime2 NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [FundingAllocation].[__EFMigrationsHistory] WHERE [MigrationId] = N'20230824081539_AddContractExpireColumn')
BEGIN
    INSERT INTO [FundingAllocation].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20230824081539_AddContractExpireColumn', N'5.0.1');
END;
GO

COMMIT;
GO

/*--------FundingAllocation-Migration-Scripts---------------*/

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_GetAwaitingProviderDetails')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_GetAwaitingProviderDetails]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_GetAwaitingProviderDetails]
AS
BEGIN

SELECT fa.ukprn, pf.providerType, pf.providerSubType, pi.lastParked
                                      FROM [FundingAllocation].[FundingAllocation] fa
									  JOIN [FundingAllocation].[ParkingAndDiscardedInfo] pi on fa.FundingId = pi.FundingAllocationId
	                                  CROSS APPLY	   (select TOP(1)   pf.providerType,
																		pf.providerSubType
														from  
														[FundingAllocation].[ProviderFundingAllocation] pfa,
														[FundingAllocation].[ProviderFunding] pf
														where fa.FundingId = pfa.FundingId
														and pfa.ProviderFundingId = pf.ProviderFundingId) pf    
                                      where 
                                      fa.FundingId = pi.FundingAllocationId
                                      and fa.Status = 'Parked'
                                      and fa.SubStatus = 'AwaitingProvider'
                                      order by pi.LastParked desc
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_GetAwaitingContractTypeDetails')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_GetAwaitingContractTypeDetails]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_GetAwaitingContractTypeDetails]
AS
BEGIN

SELECT fa.ukprn,
                                            afsc.fundingTypeCode as fcsFundingType,
	                                        afsc.FundingPeriodCode as fcsFundingPeriod,
	                                        pf.ProviderType,
				                            pf.ProviderSubType,
                                            pi.lastParked
                                    FROM [FundingAllocation].[FundingAllocation] fa
	                                JOIN [FundingAllocation].[ParkingAndDiscardedInfo] pi on fa.FundingId = pi.FundingAllocationId
			                        JOIN  [FundingAllocation].[AllocationFundingStreamConfig] afsc on fa.AllocationFundingStream = afsc.AllocationFundingStreamCode and fa.Period = afsc.AllocationPeriodId
			                        CROSS APPLY	   (select TOP(1)   pf.providerType,
											                        pf.providerSubType
							                        from  
						                            [FundingAllocation].[ProviderFundingAllocation] pfa,
						                            [FundingAllocation].[ProviderFunding] pf
				                                    where fa.FundingId = pfa.FundingId
					                                and pfa.ProviderFundingId = pf.ProviderFundingId) pf
                                    where                                   
                                    fa.Status = 'Parked'
                                    and fa.SubStatus = 'AwaitingContractTypeConfig'
                                    order by pi.lastParked desc
END
GO

COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_GetUnknownProviderTypeSubtypeDetails')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_GetUnknownProviderTypeSubtypeDetails]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_GetUnknownProviderTypeSubtypeDetails]
AS
BEGIN

SELECT [Period] CfsFundingPeriod, [ProviderType], [ProviderSubType] FROM 
                                            (
                                              SELECT DISTINCT [Period], pf.[ProviderType], pf.[ProviderSubType]
                                                FROM [FundingAllocation].[FundingAllocation] fa 
                                                INNER JOIN [FundingAllocation].[ProviderFundingAllocation] pfa
                                                ON fa.[FundingId] = pfa.[FundingId]
                                                INNER JOIN [FundingAllocation].[ProviderFunding] pf
                                                ON pfa.ProviderFundingId = pf.ProviderFundingId
                                                WHERE fa.[Status] = 'Parked' AND fa.[SubStatus] <> 'AwaitingOutcome'
                                            ) DistinctParkedRows
                                            WHERE NOT EXISTS 
                                             (SELECT 1 FROM [FundingAllocation].[ProviderTypeConfig]
                                              WHERE [Type] = DistinctParkedRows.[ProviderType] 
                                              AND [Subtype] = DistinctParkedRows.[ProviderSubType])
                                            ORDER BY [Period], [ProviderType], [ProviderSubType]
END
GO

COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_IsReleaseGroupGroupReleased')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_IsReleaseGroupGroupReleased]
  END

GO
CREATE PROCEDURE [dbo].sp_FA_IsReleaseGroupGroupReleased
@releaseGroupName nvarchar(50),
@releasedStatus nvarchar(50)
AS
BEGIN

SELECT count(1)
                                 FROM [FundingAllocation].[ReleaseGroupGroup] rgg,
                                      [FundingAllocation].ReleaseGroup rg
                                 WHERE rgg.ReleaseGroupGroupId in (
                                    select distinct ReleaseGroupGroupId 
                                    from [FundingAllocation].[ReleaseGroupGroup] rgg,
	                                     [FundingAllocation].ReleaseGroup rg
	                                where rgg.ReleaseGroupId = rg.Id
	                                and rg.ReleaseGroupName = @releaseGroupName)
                                 and rgg.ReleaseGroupId = rg.Id
                                 and rg.Status != @releasedStatus
END
GO

COMMIT;
GO
/*--------FundingAllocation-Jobs-Migration-Scripts---------------*/

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_IsFundingAllocationInReleaseGroup')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_IsFundingAllocationInReleaseGroup]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_IsFundingAllocationInReleaseGroup]
@fundingId nvarchar(200)
AS
BEGIN

SELECT count(1) FROM [FundingAllocation].[FundingAllocation] WITH (ROWLOCK, XLOCK) 
                                WHERE FundingId = @FundingId
                                AND ReleaseGroupId is not null
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_InsertOrUpdateParkingInfoLastDiscarded')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_InsertOrUpdateParkingInfoLastDiscarded]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_InsertOrUpdateParkingInfoLastDiscarded]
@fundingId nvarchar(200),
@now DATETIME
AS
BEGIN

MERGE INTO[FundingAllocation].[ParkingAndDiscardedInfo] AS Target
                                       USING (VALUES (@fundingId)) AS source (id)
                                        ON Target.FundingAllocationId = Source.Id
                                       WHEN MATCHED THEN
                                            UPDATE SET TARGET.LastDiscarded = @now  
                                       WHEN NOT MATCHED BY TARGET THEN
                                            INSERT(FundingAllocationId, LastDiscarded) VALUES(@fundingId, @now);
END
GO

COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_GetReleaseGroupsWithQueuedFundingAllocationsForContract')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_GetReleaseGroupsWithQueuedFundingAllocationsForContract]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_GetReleaseGroupsWithQueuedFundingAllocationsForContract]
@subStatus nvarchar(50),
@status nvarchar(50),
@contractNumber nvarchar(50),
@queuedRelationship nvarchar(20)
AS
BEGIN

select distinct rg.ReleaseGroupName
                                from [FundingAllocation].[FundingAllocation] fa,
                                     [FundingAllocation].[ReleaseGroup] rg,
	                                 [FundingAllocation].[Contract] c
                            where fa.SubStatus = @subStatus 
                            and fa.Status = @status
                            and fa.ReleaseGroupId = fa.ReleaseGroupId
                            and fa.ContractId = c.Id
                            and c.[RelationshipToFundingAllocation] = @queuedRelationship
                            and c.ContractNumber = @contractNumber
                            and fa.ReleaseGroupId = rg.Id
END
GO

COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_GetLatestPublishedFundingLines')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_GetLatestPublishedFundingLines]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_GetLatestPublishedFundingLines]
@fundingName nvarchar(200),
@fundingIdToIgnore nvarchar(200)
AS
BEGIN

select fal.ProviderFundingId,
       fal.FundingLineCode,
       fa.fundingId
from [FundingAllocation].[FundingAllocation] fa,
     [FundingAllocation].[FundingAllocationLine] fal,
	 [FundingAllocation].[ProviderFundingAllocation] pfa
where fa.FundingId = pfa.FundingId
and pfa.ProviderFundingId = fal.ProviderFundingId
and fa.FundingAllocationName = @fundingName
and fa.FundingId != @fundingIdToIgnore
and fa.isPublished = 1
and fal.IsOfNoInterest = 0
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_SetLinesToIsOfNoInterest')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_SetLinesToIsOfNoInterest]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_SetLinesToIsOfNoInterest]
@providerFundingId nvarchar(100),
@FundingLineCode nvarchar(50)
AS
BEGIN

update [FundingAllocation].[FundingAllocationLine] 
                                 set IsOfNoInterest = 1
                                 where ProviderFundingId = @providerFundingId
                                 and FundingLineCode = @fundingLineCode
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_IsPostReadMissingProviderCheckComplete')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_IsPostReadMissingProviderCheckComplete]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_IsPostReadMissingProviderCheckComplete]
@parkedPending nvarchar(50),
@providerCheck nvarchar(50)
AS
BEGIN

select count(1) from [FundingAllocation].[FundingAllocation]
                                  where ReadId in ( select ReadId from [FundingAllocation].[FeedRead]
                                  where ReadId not in (select max(ReadId) from [FundingAllocation].[FeedRead]))
                                  and Status = @parkedPending
                                  and SubStatus = @providerCheck
END
GO

COMMIT;
GO

/*--------------------------Funding Allocation Types--------------------------------------------------------*/

BEGIN TRANSACTION;
GO
IF NOT EXISTS (SELECT * FROM SYS.TYPES
WHERE is_user_defined = 1 AND Name IN ('FundingIdsUDT'))     
    BEGIN
        CREATE TYPE [dbo].[FundingIdsUDT] as Table
        (
        FundingIds varchar(50)
        )
    END
    GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF NOT EXISTS (SELECT * FROM SYS.TYPES
WHERE is_user_defined = 1 AND Name IN ('FundingAllocationNamesUDT'))     
    BEGIN
         CREATE TYPE FundingAllocationNamesUDT AS TABLE (
	                    FundingAllocationName nvarchar(200))
                    
    END
    GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF NOT EXISTS (SELECT * FROM SYS.TYPES
WHERE is_user_defined = 1 AND Name IN ('FundingAllocationIdsUDT'))     
    BEGIN
        CREATE TYPE FundingAllocationIdsUDT AS TABLE (
	                    FundingId nvarchar(200))
                    
    END
    GO
COMMIT;
GO

----------------------------END TYPES-------------------------------------------------------------------------------


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_SetFundingAllocationStatusSubStatus')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_SetFundingAllocationStatusSubStatus]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_SetFundingAllocationStatusSubStatus]
@fundingIds [dbo].[FundingIdsUDT] READONLY,
@status nvarchar(50),
@substatus nvarchar(50)
AS
BEGIN

UPDATE [FundingAllocation].[FundingAllocation] 
                         SET Status = @status,
                             SubStatus = @subStatus
                         WHERE FundingId in (select FundingIds from @fundingIds)
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FA_UpdateFundingAllocations')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FA_UpdateFundingAllocations]
  END

GO
CREATE PROCEDURE [dbo].[sp_FA_UpdateFundingAllocations]
@fundingIds [dbo].[FundingIdsUDT] READONLY,
@releaseGroupId int,
@status nvarchar(50),
@substatus nvarchar(50)

AS
BEGIN

UPDATE [FundingAllocation].[FundingAllocation] 
                         SET Status = @status,
                             SubStatus = @SubStatus,
                             ReleaseGroupId = @releaseGroupId
                         WHERE FundingId in  (select FundingIds from @fundingIds)
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'FundingAllocation'
                  AND ROUTINE_NAME = 'GetAllocationLineConfigs')
  BEGIN
     DROP PROCEDURE FundingAllocation.GetAllocationLineConfigs
  END

GO
 CREATE PROCEDURE FundingAllocation.GetAllocationLineConfigs
	                    @allocationFundingStreamCode nvarchar(50),
                        @allocationPeriodId nvarchar(50),
                        @fundingLineCode nvarchar(50)
                    AS
                    BEGIN
	                    SELECT alc.FspCode,
                          alc.DeliverableCode,
                          alc.ProviderCategory,
                          d.DeliverableName,
                          d.DisplayOrder,
                          fsp.FundingStreamCode,
                          fsp.AllocationReferencePrefix
                   FROM [FundingAllocation].[AllocationLineConfig] alc,
                        [FundingAllocation].[FspDeliverableConfig] d,   
                        [FundingAllocation].[FundingStreamPeriodConfig] fsp
                   WHERE alc.fspCode = d.fspcode
                   and alc.deliverableCode = d.deliverableCode
                   and d.FspCode = fsp.FundingStreamPeriodCode
                   and alc.[FundingStreamCode] = @allocationFundingStreamCode
                   AND alc.[PeriodId] = @allocationPeriodId
                   AND alc.[FundingLineCode] = @fundingLineCode
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'FundingAllocation'
                  AND ROUTINE_NAME = 'IsReadComplete')
  BEGIN
     DROP PROCEDURE FundingAllocation.IsReadComplete
  END

GO
 CREATE PROCEDURE FundingAllocation.IsReadComplete
	                    @fundingId nvarchar(200)
                    AS
                    BEGIN
	                    SELECT
                                      funding.ReadId,

                                      (SELECT COUNT(1)
                                      FROM [FundingAllocation].[FundingAllocationPageControl] pc
                                      WHERE pc.LatestBookmarkOnPage IS NULL
                                      AND pc.ReadId = funding.ReadId)  AS pagesYetToRead,

                                      (SELECT COUNT(1)
                                      FROM (SELECT fa.ProviderFundingCount AS expectedNumProviders,
                                            (SELECT COUNT(1)
                                            FROM [FundingAllocation].[ProviderFundingAllocation] pfa
                                            WHERE pfa.FundingId = fa.FundingId)	AS actualNumProviders
                                            FROM [FundingAllocation].[FundingAllocation] fa
                                            WHERE fa.ReadId = funding.ReadId) t
                                      WHERE t.expectedNumProviders != t.actualNumProviders)  AS totalFAsWithMissingProviders

                                FROM [FundingAllocation].[FundingAllocation] funding
                                WHERE funding.FundingId = @fundingId
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'FundingAllocation'
                  AND ROUTINE_NAME = 'UpdateParkingInfoForDiscarded')
  BEGIN
     DROP PROCEDURE FundingAllocation.UpdateParkingInfoForDiscarded
  END

GO
 CREATE PROCEDURE FundingAllocation.UpdateParkingInfoForDiscarded	                    
                        @discardedStatus nvarchar(50),
                        @now DATETIME,
                        @fundingAllocationNames FundingAllocationNamesUDT READONLY,
                        @readIdToIgnore int
                        
                    AS
                    BEGIN
	                    UPDATE pi
                                  SET LastDiscarded = @now
                                  FROM [FundingAllocation].ParkingAndDiscardedInfo AS pi
                                  WHERE EXISTS
                                  (
                                    select 1 from [FundingAllocation].[FundingAllocation]
                                    where FundingAllocationName in (Select FundingAllocationName from @fundingAllocationNames)
                                    and Status = @discardedStatus
                                    and ReadId <> @readIdToIgnore
	                                and FundingId = pi.FundingAllocationId
                                  )
                                  AND pi.LastDiscarded is null
                    END
GO

COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'FundingAllocation'
                  AND ROUTINE_NAME = 'GetReleaseGroupsThatCanNowBeSetToReleased')
  BEGIN
     DROP PROCEDURE FundingAllocation.GetReleaseGroupsThatCanNowBeSetToReleased
  END

GO
 CREATE PROCEDURE FundingAllocation.GetReleaseGroupsThatCanNowBeSetToReleased	
                        @fundingAllocationIds FundingAllocationIdsUDT READONLY,
                        @schedulingStatus nvarchar(50),
                        @awaitingReleaseSubStatus nvarchar(50),
                        @releaseGroupId int,
                        @createdRelationship nvarchar(20)
                        
                    AS
                    BEGIN
	                    SELECT ReleaseGroupName, 
                                (select count(1) from [FundingAllocation].[FundingAllocation] where ReleaseGroupId = rg.ReleaseGroupId) totalInGroup,
                                (select count(1) from [FundingAllocation].[FundingAllocation] fa, [FundingAllocation].[Contract] c                     
                                 where fa.ReleaseGroupId = rg.ReleaseGroupId
                                 and fa.ContractId = c.Id
                                 and c.[RelationshipToFundingAllocation] = @createdRelationship
                                 and c.IsCreatedInCrm = 1) numWithContract,
                                (select count(1) from [FundingAllocation].[FundingAllocation] where ReleaseGroupId = rg.ReleaseGroupId
                                 and Status = @schedulingStatus
                                 and SubStatus = @awaitingReleaseSubStatus) totalQueued
                                from(
                                      select distinct rg.Id as ReleaseGroupId,
                                                      rg.[ReleaseGroupName]
                                      FROM [FundingAllocation].[ReleaseGroup] rg
                                      LEFT JOIN [FundingAllocation].[FundingAllocation] fa
                                      ON rg.Id = fa.ReleaseGroupId
                                      where
                                      (fa.FundingId in (select FundingId from @fundingAllocationIds)  OR
                                      rg.ID = @releaseGroupId)) rg
                    END
GO

COMMIT;
GO

-------------------------------------------------* Funding Allocation Console application related scrips *--------------------------------------------------

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'Dbo'
                  AND ROUTINE_NAME = 'sp_config_dynamic_InsertRow')
  BEGIN
     DROP PROCEDURE Dbo.sp_config_dynamic_InsertRow
  END

GO
 CREATE PROCEDURE [dbo].[sp_config_dynamic_InsertRow]
       @count int,
	  @schemaName NVARCHAR(MAX),
     @tableName NVARCHAR(MAX),    
	 @param1 nvarchar(100)=null,
	 @param2 nvarchar(100)=null,
	 @param3 nvarchar(100)=null,
	 @param4 nvarchar(100)=null,
	 @param5 nvarchar(100)=null,
	 @param6 nvarchar(100)=null,
	 @column1  nvarchar(50)=null,
	 @column2 nvarchar(50)=null,
	 @column3 nvarchar(50)=null,
	 @column4 nvarchar(50)=null,
	 @column5 nvarchar(50)=null,
	 @column6 nvarchar(50)=null

AS
BEGIN
 DECLARE @Sql NVARCHAR(max)
  IF @count=2  		
			 BEGIN
    SET @Sql='INSERT INTO '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName)+'('+
                                       @column1
                                       +','+@column2+')'
                                 +'VALUES('+
                                       +''''+@param1
                                       +''','''+@param2+''')'									  
			 
             END  
 IF @count=3  		
			 BEGIN
    SET @Sql='INSERT INTO '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName)+'('+
                                       @column1
                                       +','+@column2
                                       +','+@column3+')'
                                 +'VALUES('+
                                       +''''+@param1
                                       +''','''+@param2
                                       +''','''+@param3+''')'									  
			 
             END  
 ELSE IF @count=4  		
			 BEGIN
    SET @Sql='INSERT INTO '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName)+'('+
                                       @column1
                                       +','+@column2
                                       +','+@column3
                                       +','+@column4+')'
                                 +'VALUES('+
                                       +''''+@param1
                                       +''','''+@param2
                                       +''','''+@param3
                                       +''','''+@param4+''')'									  
			 
             END  
  ELSE  IF @count=5
             BEGIN
			 SET @Sql='INSERT INTO '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName)+'('+
                                       @column1
                                       +','+@column2
                                       +','+@column3
                                       +','+@column4
									   +','+@column5+')'
                                 +'VALUES('+
                                       +''''+@param1
                                       +''','''+@param2
                                       +''','''+@param3
                                       +''','''+@param4
									   +''','''+@param5+''')'
			
			 END
 ELSE  IF @count=6
             BEGIN
			 SET @Sql='INSERT INTO '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName)+'('+
                                       @column1
                                       +','+@column2
                                       +','+@column3
                                       +','+@column4
									   +','+@column5
									   +','+@column6+')'
                                 +'VALUES('+
                                       +''''+@param1
                                       +''','''+@param2
                                       +''','''+@param3
                                       +''','''+@param4
									   +''','''+@param5
									   +''','''+@param6+''')'	
			
			 END	
			 EXECUTE sp_executesql @Sql
END
GO

COMMIT;
GO



BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'Dbo'
                  AND ROUTINE_NAME = 'sp_config_dynamic_DeleteRow')
  BEGIN
     DROP PROCEDURE Dbo.sp_config_dynamic_DeleteRow
  END

GO
 CREATE PROCEDURE [dbo].[sp_config_dynamic_DeleteRow]
       @count int,
	  @schemaName NVARCHAR(MAX),
     @tableName NVARCHAR(MAX),    
	 @param1 nvarchar(100)=null,
	 @param2 nvarchar(100)=null,
	 @param3 nvarchar(100)=null,
	 @param4 nvarchar(100)=null,
	 @column1  nvarchar(50)=null,
	 @column2 nvarchar(50)=null,
	 @column3 nvarchar(50)=null,
	 @column4 nvarchar(50)=null

AS
BEGIN
 DECLARE @Sql NVARCHAR(max)
 IF @count=1  		
			 BEGIN
     
			SET @Sql='DELETE FROM '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+' 
                                 WHERE '+ @column1+' = '''+ @param1+''''
                                   							  
			 
             END  
  IF @count=2  		
			 BEGIN
     
			SET @Sql='DELETE FROM '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+' 
                                 WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+''''
                                   							  
			 
             END  
 IF @count=3  		
			 BEGIN

			SET @Sql='DELETE FROM '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+' 
                                 WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+'''
                                   AND '+ @column3+' = '''+@param3+''''								  								  
			 
             END  
 
 IF @count=4  		
			 BEGIN

			SET @Sql='DELETE FROM '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+' 
                                 WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+'''
                                   AND '+ @column3+' = '''+@param3+'''	
								   AND '+ @column4+' = '''+@param4+''''	
			 
             END  

 			 EXECUTE sp_executesql @Sql
END

GO

COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'Dbo'
                  AND ROUTINE_NAME = 'sp_config_dynamic_IsRowPresent')
  BEGIN
     DROP PROCEDURE Dbo.sp_config_dynamic_IsRowPresent
  END

GO
 Create PROCEDURE [dbo].[sp_config_dynamic_IsRowPresent]
       @count int,
	  @schemaName NVARCHAR(MAX),
     @tableName NVARCHAR(MAX),    
	 @param1 nvarchar(100)=null,
	 @param2 nvarchar(100)=null,
	 @param3 nvarchar(100)=null,
	 @param4 nvarchar(100)=null,
	 @param5 nvarchar(100)=null,
	 @column1  nvarchar(50)=null,
	 @column2 nvarchar(50)=null,
	 @column3 nvarchar(50)=null,
	 @column4 nvarchar(50)=null,
	 @column5 nvarchar(50)=null

AS
BEGIN
 DECLARE @Sql NVARCHAR(max)
 IF @count=1  		
			 BEGIN
     
			SET @Sql='SELECT COUNT(1) FROM  '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+'
                                 WHERE '+ @column1+' = '''+ @param1+''''
                                   							  
			 
             END  
  IF @count=2  		
			 BEGIN
     
			SET @Sql='SELECT COUNT(1) FROM  '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+'
                                 WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+''''
                                   							  
			 
             END  
 IF @count=3  		
			 BEGIN

			SET @Sql='SELECT COUNT(1) FROM  '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+'
                                 WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+'''
                                   AND '+ @column3+' = '''+@param3+''''
								  								  
			 
             END  
 ELSE IF @count=4  		
			 BEGIN
   
									   
			 SET @Sql='SELECT COUNT(1) FROM  '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+'
                                 WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+'''
                                   AND '+ @column3+' = '''+@param3+'''
								   AND '+ @column4+' = '''+@param4+''''
								  
			 
             END  
 			 EXECUTE sp_executesql @Sql
END

GO

COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'Dbo'
                  AND ROUTINE_NAME = 'sp_config_dynamic_UpdateRow')
  BEGIN
     DROP PROCEDURE Dbo.sp_config_dynamic_UpdateRow
  END

GO

 CREATE PROCEDURE [dbo].[sp_config_dynamic_UpdateRow]
       @count int,
	  @schemaName NVARCHAR(MAX),
     @tableName NVARCHAR(MAX),    
	 @param1 nvarchar(100)=null,
	 @param2 nvarchar(100)=null,
	 @param3 nvarchar(100)=null,
	 @param4 nvarchar(100)=null,
	 @param5 nvarchar(100)=null,
	 @param6 nvarchar(100)=null,
	 @column1  nvarchar(50)=null,
	 @column2 nvarchar(50)=null,
	 @column3 nvarchar(50)=null,
	 @column4 nvarchar(50)=null,
	 @column5 nvarchar(50)=null,
	 @column6 nvarchar(50)=null

AS
BEGIN
 DECLARE @Sql NVARCHAR(max)
  IF @count=2  		
			 BEGIN
     SET @Sql=  'UPDATE '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+'
			                       SET '+ QUOTENAME(@column2)+' = '''+@param2+''' 
					               WHERE '+ @column1+' = '''+ @param1+''''
                                   							  
			 
             END  
 IF @count=3  		
			 BEGIN
   							   
			 SET @Sql=  'UPDATE '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+'
			                       SET '+ QUOTENAME(@column3)+' = '''+@param3+''' 
					               WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+''''
								  								  
			 
             END  
 ELSE IF @count=4  		
			 BEGIN
   
									   
			 SET @Sql=  'UPDATE '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+'
			                       SET '+ QUOTENAME(@column4)+' = '''+@param4+''' 
					               WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+'''
                                   AND '+ @column3+' = '''+@param3+''''
								  
			 
             END  
  ELSE  IF @count=5
             BEGIN
			 SET @Sql='UPDATE '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+' 
                                   SET '+ QUOTENAME(@column3)+' = '''+ @param3+''', 
								   '+ QUOTENAME(@column4)+' = '''+@param4+''',
								   '+ QUOTENAME(@column5)+' = '''+@param5+'''                                     
                                   WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+''''
								   
			
			 END
 ELSE  IF @count=6
             BEGIN
			 SET @Sql='UPDATE '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+' 
                                   SET '+ QUOTENAME(@column5)+' = '''+ @param5+''', 
								   '+ QUOTENAME(@column6)+' = '''+@param6+'''
								                                        
                                   WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+'''
								   AND '+ @column3+' = '''+@param3+'''
								   AND '+ @column4+' = '''+@param4+''''
								  
			
			 END	
ELSE  IF @count=7
             BEGIN
			 SET @Sql='UPDATE '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+' 
                                   SET '+ QUOTENAME(@column3)+' = '''+ @param3+''', 
								   '+ QUOTENAME(@column4)+' = '''+@param4+'''
								                                        
                                   WHERE '+ @column1+' = '''+ @param1+'''
                                   AND '+ @column2+' = '''+@param2+''''
								  
			
			 END	
			 EXECUTE sp_executesql @Sql
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'Dbo'
                  AND ROUTINE_NAME = 'sp_config_fa_fsp_Dynamic')
  BEGIN
     DROP PROCEDURE Dbo.sp_Config_FA_FSP_Dynamic
  END

GO
 CREATE PROCEDURE [dbo].[sp_Config_FA_FSP_Dynamic]
     @processType nvarchar(20),
	 @schemaName NVARCHAR(MAX),
     @tableName NVARCHAR(MAX),    
	 @param1 nvarchar(100)=null,
	 @param2 nvarchar(100)=null,
	 @param3 nvarchar(100)=null,
	 @param4 DATETIME,
	 @param5 DATETIME,
	 @column1  nvarchar(50),
	 @column2 nvarchar(50),
	 @column3 nvarchar(50),
	 @column4 nvarchar(50),
	 @column5 nvarchar(50)

AS
BEGIN

 DECLARE @Sql NVARCHAR(max)

  IF @processType='InsertRow' 		
			 BEGIN

     SET @Sql='INSERT INTO '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName)+'('+
                                       @column1
                                       +','+@column2
                                       +','+@column3
                                       +','+@column4
									   +','+@column5+')'
                                 +'VALUES('+
                                       +''''+@param1
                                       +''','''+@param2
                                       +''','''+@param3
                                       +''',@param4,@param5)';								   

                                   	
								   	
			
             END  

  IF @processType='UpdateRow' 	
  
			 BEGIN
   							   
			 SET @Sql='UPDATE '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+' 
                                   SET '+ @column2+' = '''+ @param2+''', 
								   '+ @column3+' = '''+@param3+''',
								   '+ @column4+' = @param4,
								   '+ @column5+' = @param5                                      
                                   WHERE '+ @column1+' = '''+ @param1+''''								  								  
			 
             END  
			 
			 EXECUTE sp_executesql @Sql,N'@param4 DATETIME,@param5 DATETIME',@param4,@param5
			 
END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'Dbo'
                  AND ROUTINE_NAME = 'sp_Config_FA_FTFP_Dynamic')
  BEGIN
     DROP PROCEDURE Dbo.sp_Config_FA_FTFP_Dynamic
  END

GO
 CREATE PROCEDURE [dbo].[sp_Config_FA_FTFP_Dynamic]
     @processType nvarchar(20),
	 @schemaName NVARCHAR(MAX),
     @tableName NVARCHAR(MAX),    
	 @param1 nvarchar(100)=null,
	 @param2 nvarchar(100)=null,
	 @param3 nvarchar(100)=null,
	 @param4 nvarchar(100)=null,
	 @param5 nvarchar(100)=null,
	 @param6 BIT,
	 @param7 BIT,
	 @param8 BIT,
	 @param9 DATETIME,
	 @column1 nvarchar(50),
	 @column2 nvarchar(50),
	 @column3 nvarchar(50),
	 @column4 nvarchar(50),
	 @column5 nvarchar(50),
	 @column6 nvarchar(50),
	 @column7 nvarchar(50),
	 @column8 nvarchar(50),
	 @column9 nvarchar(50)

AS
BEGIN

 DECLARE @Sql NVARCHAR(max)

  IF @processType='InsertRow' 		
			 BEGIN

     SET @Sql='INSERT INTO '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName)+'('+
                                       @column1
                                       +','+@column2
                                       +','+@column3
                                       +','+@column4
									   +','+@column5
									    +','+@column6
										 +','+@column7
										  +','+@column8
										   +','+@column9+')'
                                 +'VALUES('+
                                       +''''+@param1
                                       +''','''+@param2
                                       +''',@param3,@param4,@param5,@param6,@param7,@param8
                                       ,@param9)';								   

                                   	
								   	
			
             END  

  IF @processType='UpdateRow' 	
  
			 BEGIN
   							   
			 SET @Sql='UPDATE '+ QUOTENAME(@schemaName)+'.'+QUOTENAME(@tableName )+' 
                                   SET '+ @column3+' = @param3, 
								   '+ @column4+' = @param4,
								   '+ @column5+' = @param5,
								   '+ @column6+' = @param6, 
								   '+ @column7+' = @param7, 
								   '+ @column8+' = @param8, 
								   '+ @column9+' = @param9
                                   WHERE '+ @column1+' = '''+ @param1+'''								  								  
			                       AND '+ @column2+' = '''+ @param2+''''
             END  
			 
			 EXECUTE sp_executesql @Sql,N'@param3 nvarchar(100),@param4 nvarchar(100),@param5 nvarchar(100),@param6 BIT,@param7 BIT,@param8 BIT,@param9 DATETIME',@param3,@param4,@param5,@param6,@param7,@param8,@param9
			 
END
GO

COMMIT;
GO

--------------* Type RowsToProcess *---------------

BEGIN TRANSACTION;
GO
IF NOT EXISTS (SELECT * FROM SYS.TYPES
WHERE is_user_defined = 1 AND Name IN ('RowsToProcessUDT'))    
    BEGIN
        CREATE TYPE [dbo].[RowsToProcessUDT] as Table
        (
       [FundingTypeCode] [nvarchar](50) NULL,
	   [FundingPeriodCode] [nvarchar](50) NULL,
	   [UKPRN] [nvarchar](50) NULL,
	   [Category] [nvarchar](50) NULL
        )
    END
    GO
COMMIT;
GO

--------------* ENDType RowsToProcess *---------------

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'Dbo'
                  AND ROUTINE_NAME = 'sp_ProviderCategoryException_ProcessRows')
  BEGIN
     DROP PROCEDURE Dbo.sp_ProviderCategoryException_ProcessRows
  END

GO
 CREATE PROCEDURE [dbo].[sp_ProviderCategoryException_ProcessRows]      
	   @RowsToProcess dbo.RowsToProcessUDT Readonly,
	    @processtype varchar(20)
	   
AS
BEGIN


 IF @processtype='InsertSql'  
 
			 BEGIN
							 insert into [FundingAllocation].[ProviderCategoryException]
                                            (FundingTypeCode, FundingPeriodCode, UKPRN, Category)
                                          select * from @RowsToProcess										  	
             END  
 ELSE IF @processtype='UpdateSql'  		
			 BEGIN
			 

			  Update [FundingAllocation].[ProviderCategoryException] 
                                          set [FundingAllocation].[ProviderCategoryException].Category =  r.Category from @RowsToProcess r
                                          where [FundingAllocation].[ProviderCategoryException].FundingTypeCode = r.FundingTypeCode  
                                            and [FundingAllocation].[ProviderCategoryException].FundingPeriodCode = r.FundingPeriodCode 
                                            and [FundingAllocation].[ProviderCategoryException].UKPRN = r.UKPRN
											
			 
             END  
  ELSE  IF @processtype='DeleteSql'
             BEGIN
			 
			 
											delete from [FundingAllocation].[ProviderCategoryException] 
                                           where exists(select null from @RowsToProcess r where [FundingAllocation].[ProviderCategoryException].FundingTypeCode = r.FundingTypeCode   
                                             and [FundingAllocation].[ProviderCategoryException].FundingPeriodCode =r.FundingPeriodCode
                                             and [FundingAllocation].[ProviderCategoryException].UKPRN =r.UKPRN
                                             and [FundingAllocation].[ProviderCategoryException].Category =r.Category)	
			
			 END 
			
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_config_FspDeliverables_InsertRow')
  BEGIN
     DROP PROCEDURE dbo.sp_config_FspDeliverables_InsertRow
  END

GO
 CREATE PROCEDURE dbo.sp_config_FspDeliverables_InsertRow
	                    @FundingStreamPeriodCode nvarchar(50),
                        @DeliverableCode int,
                        @DeliverableName nvarchar(100),
                        @DisplayOrder int
                    AS
                    BEGIN
	                      
            insert into [FundingAllocation].[FspDeliverableConfig]
                               ([FspCode]
                                    ,[DeliverableCode]
                                   ,[DeliverableName]
                                   ,[DisplayOrder])
                               values(@FundingStreamPeriodCode, @DeliverableCode, @DeliverableName, @DisplayOrder)

END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_config_FspDeliverables_UpdateRow')
  BEGIN
     DROP PROCEDURE dbo.sp_config_FspDeliverables_UpdateRow
  END

GO
 CREATE PROCEDURE dbo.sp_config_FspDeliverables_UpdateRow
                    @FundingStreamPeriodCode nvarchar(50),
                       @DeliverableCode int,
                       @DeliverableName nvarchar(100),
                       @DisplayOrder int
                   AS
                   BEGIN
                      
                   Update [FundingAllocation].[FspDeliverableConfig] set 
                                    [DeliverableName] = @DeliverableName
                                   ,[DisplayOrder] = @DisplayOrder
                                where
                                    [FspCode] = @FundingStreamPeriodCode
                                and [DeliverableCode] = @DeliverableCode
				   END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_config_update_overridedate')
  BEGIN
     DROP PROCEDURE dbo.sp_config_update_overridedate
  END

GO
 CREATE PROCEDURE dbo.sp_config_update_overridedate
                    @date DATETIME
                   AS
                   BEGIN
                      
                  MERGE INTO[OverrideDate].[OverrideDate] AS Target
   USING (VALUES (@date)) AS source (date)
    ON Target.SystemOverrideDate is not null
   WHEN MATCHED THEN
        UPDATE SET TARGET.SystemOverrideDate = @date  
   WHEN NOT MATCHED BY TARGET THEN
        INSERT(SystemOverrideDate) VALUES(@date);
				   END
GO
COMMIT;
GO


--------------------------------------------------------- * END Funding Allocation config related scripts *----------------------------------------------------


-----------------------------------* Bulk Import * ------------------------------------


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'FundingAllocation'
                  AND ROUTINE_NAME = 'DeleteContractIfOrphaned')
  BEGIN
     DROP PROCEDURE FundingAllocation.DeleteContractIfOrphaned
  END

GO

CREATE PROCEDURE FundingAllocation.DeleteContractIfOrphaned	                        
                        @contractNumber nvarchar(50),
                        @contractVersionNumber int,
                        @contractSubversionNumber int
                        
                    AS
                    BEGIN
	                    delete from [FundingAllocation].[Contract]
                                 where id NOT in (select ISNULL(fa.ContractId, -1)
                                                 from [FundingAllocation].[FundingAllocation] fa)
                                 and ContractNumber = @contractNumber
                                 and ContractVersionNumber = @contractVersionNumber
                                 and ContractSubVersionNumber = @contractSubversionNumber
                    END
                    GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'FundingAllocation'
                  AND ROUTINE_NAME = 'CreateContractWithQueuedRelationshipOrReturnExistingId')
  BEGIN
     DROP PROCEDURE FundingAllocation.CreateContractWithQueuedRelationshipOrReturnExistingId
  END

GO

CREATE PROCEDURE [FundingAllocation].[CreateContractWithQueuedRelationshipOrReturnExistingId]	                        
     @contractNumber nvarchar(50),
     @contractVersionNumber int,
     @contractSubversionNumber int,
	 @isCreatedInCrm BIT=0,
     @queued nvarchar(20)
 AS
 BEGIN
     IF (NOT EXISTS(SELECT null from [FundingAllocation].[Contract] 
                             where ContractNumber = @contractNumber
                             and ContractVersionNumber = @contractVersionNumber
                             and ContractSubVersionNumber = @contractSubVersionNumber
                             and RelationshipToFundingAllocation = @queued))
                  BEGIN
                     INSERT INTO [FundingAllocation].[Contract]
                     ([ContractNumber]
                     ,[ContractVersionNumber]
                     ,[ContractSubVersionNumber]
                     ,[IsCreatedInCrm]
                     ,[RelationshipToFundingAllocation])
                     OUTPUT Inserted.Id
                     VALUES
                         (@contractNumber, @contractVersionNumber, @contractSubVersionNumber,@isCreatedInCrm, @queued)
                  END
              ELSE
                 BEGIN
                     SELECT ID from [FundingAllocation].[Contract]
                      where ContractNumber = @contractNumber
                                 and ContractVersionNumber = @contractVersionNumber
                                 and ContractSubVersionNumber = @contractSubVersionNumber
                                 and RelationshipToFundingAllocation = @queued
                 END
 END
 GO

COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Worker_FindAllocationNumberByUkprnAndFspCode')
  BEGIN
     DROP PROCEDURE dbo.sp_Worker_FindAllocationNumberByUkprnAndFspCode
  END

GO

CREATE PROCEDURE [dbo].[sp_Worker_FindAllocationNumberByUkprnAndFspCode]
    @ukprn int,
    @fspCode nvarchar(100)
AS
BEGIN
    SELECT alloc.ContractAllocationNumber FROM ContractManagement.ApprovedContract con
    INNER JOIN ContractManagement.ApprovedContractAllocation AS alloc ON con.ApprovedContractId = alloc.ApprovedContractId
    WHERE con.Ukprn = @ukprn AND alloc.FundingStreamPeriodCode = @fspCode
    								and con.ApprovedContractId in(
    SELECT max(con.approvedcontractId) FROM ContractManagement.ApprovedContract con
    INNER JOIN ContractManagement.ApprovedContractAllocation AS alloc ON con.ApprovedContractId = alloc.ApprovedContractId
    WHERE con.Ukprn = @ukprn AND alloc.FundingStreamPeriodCode = @fspCode)
END
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Worker_GetLatestCreatedDateforApproveContract')
  BEGIN
     DROP PROCEDURE dbo.sp_Worker_GetLatestCreatedDateforApproveContract
  END

GO

CREATE PROCEDURE [dbo].[sp_Worker_GetLatestCreatedDateforApproveContract]
 @contractNumber nvarchar(50),
 @notificationAmendmentType int 
 AS
 BEGIN

                                SELECT TOP 1 cc.[CreatedDate]
                                FROM       [ContractManagement].[CreatedContract] cc 
                                INNER JOIN [ContractManagement].[ApprovedContract] ac
                                ON    cc.ContractNumber = ac.ContractNumber
                                AND   cc.ContractVersionNumber = ac.ContractVersionNumber
                                AND   cc.ContractSubVersionNumber = ac.ContractSubVersionNumber
                                WHERE cc.ContractNumber = @contractNumber
                                AND   ISNULL(cc.AmendmentType, -1) != @notificationAmendmentType
                                ORDER BY cc.ContractVersionNumber DESC, cc.ContractSubVersionNumber DESC
                                                    
END
GO

COMMIT;
GO





-------------------------------------* End Bulk Import * ------------------------------------------------------

