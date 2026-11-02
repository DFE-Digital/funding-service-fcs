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
    CREATE TABLE [Operations].[FundingReportFSP] (
        [FspCode] nvarchar(100) NOT NULL,
        [FundingPeriod] nvarchar(100) NOT NULL,
        [Order] int NOT NULL,
        [Description] nvarchar(150) NOT NULL,
        [CreatedDate] datetime NOT NULL DEFAULT ((getutcdate())),
        CONSTRAINT [PK_Operations.FundingReportFSP] PRIMARY KEY ([FspCode], [FundingPeriod])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE TABLE [Operations].[FundingReportProvider] (
        [Ukprn] int NOT NULL,
        [FundingPeriod] nvarchar(50) NOT NULL,
        [Type] nvarchar(30) NOT NULL,
        [Period] int NOT NULL,
        [CreatedDate] datetime NOT NULL DEFAULT ((getutcdate())),
        CONSTRAINT [PK_Operations.FundingReportProvider] PRIMARY KEY ([Ukprn], [FundingPeriod])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20240103140727_CreateTableLAFundingReportProvider')
BEGIN
    CREATE TABLE [Operations].[LaFundingReportProvider] (
        [Ukprn] int NOT NULL,
        [FundingPeriod] nvarchar(50) NOT NULL,
        [Type] nvarchar(30) NOT NULL,
        [Period] int NOT NULL,
        [CreatedDate] datetime NOT NULL DEFAULT ((getutcdate())),
        CONSTRAINT [PK_Operations.LaFundingReportProvider] PRIMARY KEY ([Ukprn], [FundingPeriod])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20240103140727_CreateTableLAFundingReportProvider')
BEGIN
    INSERT INTO [Operations].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20240103140727_CreateTableLAFundingReportProvider', N'5.0.1');
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    CREATE TABLE [Operations].[FundingStreamPeriod] (
        [FundingStreamPeriodCode] nvarchar(100) NOT NULL,
        [PeriodTypeCode] nvarchar(50) NOT NULL,
        [CreatedDate] datetime NOT NULL DEFAULT ((getutcdate())),
        CONSTRAINT [PK_Operations.FundingStreamPeriod] PRIMARY KEY ([FundingStreamPeriodCode])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211026130707_Initial')
BEGIN
    INSERT INTO [Operations].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20211026130707_Initial', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211207170848_NewTableConnectivity')
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

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20211207170848_NewTableConnectivity')
BEGIN
    INSERT INTO [Operations].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20211207170848_NewTableConnectivity', N'5.0.1');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20220420104455_AvailableActualsCollectionTable')
BEGIN
    CREATE TABLE [Operations].[AvailableActualsCollection] (
        [CollectionType] nvarchar(20) NOT NULL,
        [CollectionReturnCode] nvarchar(20) NOT NULL,
        [ClosedDateTime] datetime NOT NULL,
        [TotalItems] int NOT NULL,
        [CreatedDate] datetime2 NOT NULL DEFAULT (GETUTCDATE()),
        CONSTRAINT [PK_Operations.AvailableActualsCollection] PRIMARY KEY ([CollectionType], [CollectionReturnCode])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [Operations].[__EFMigrationsHistory] WHERE [MigrationId] = N'20220420104455_AvailableActualsCollectionTable')
BEGIN
    INSERT INTO [Operations].[__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20220420104455_AvailableActualsCollectionTable', N'5.0.1');
END;
GO

CREATE OR ALTER PROCEDURE [dbo].[DeleteAuditDataBatchwise] @removeOlderThanDate datetime
                AS
                    BEGIN
	                    DECLARE @keepgoing bit = 1;

	                    WHILE (@keepgoing = 1)
	                    BEGIN
		                      DELETE TOP (5000) [Operations].[AuditMessage] WHERE CreatedDate < @removeOlderThanDate

		                     IF (@@ROWCOUNT = 0) SET @keepgoing = 0;
	                    END


                    END
                 GO

IF NOT EXISTS(SELECT name FROM sys.indexes WHERE name = N'IX_AuditMessage_CreatedDate')
  BEGIN                  

                CREATE NONCLUSTERED INDEX IX_AuditMessage_CreatedDate ON [Operations].[AuditMessage] (CreatedDate DESC);   
  END;
  GO  
 ALTER INDEX IX_AuditMessage_CreatedDate ON [Operations].[AuditMessage] REBUILD ;
 GO


COMMIT;
GO


/*--------Integrity-check-Migration-Scripts---------------*/
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_OpsWeb_GetCfsImportInfos')
  BEGIN
     DROP PROCEDURE [dbo].[sp_OpsWeb_GetCfsImportInfos]
  END

GO
CREATE PROCEDURE [dbo].[sp_OpsWeb_GetCfsImportInfos]
@startRow int,
@numRows int
AS
BEGIN

SELECT r.CreatedDate RunStart, r.JobCompletedDate RunEnd,
		                                        CASE WHEN CfsReadCompletedDate IS NULL THEN 'No' ELSE 'Yes' END AS AllFundingAllocationsRead,
		                                        CASE WHEN JobCompletedDate     IS NULL THEN 'No' ELSE 'Yes' END AS AllFundingAllocationsProcessed,
		                                        (SELECT COUNT(1) FROM [FundingAllocation].[FundingAllocation] fa WHERE fa.ReadId = r.readid) AS FundingAllocationsReceived,
		                                        (SELECT COUNT(distinct pfa.ProviderFundingId) FROM [FundingAllocation].[FundingAllocation] fa
			                                        INNER JOIN [FundingAllocation].[ProviderFundingAllocation] pfa ON fa.FundingId = pfa.FundingId WHERE fa.ReadId = r.readid) AS ProviderFundingsReceived,
		                                        (SELECT COUNT(1) FROM [FundingAllocation].[FundingAllocation] fa WHERE fa.ReadId = r.readid AND CrmEntityId IS NOT NULL) AS FundingAllocationPutInCrm,
		                                        (SELECT COUNT(1) FROM [FundingAllocation].[FundingAllocation] fa WHERE fa.ReadId = r.readid AND status = 'Discarded') FundingAllocationsDiscarded,
		                                        (SELECT COUNT(1) FROM [FundingAllocation].[FundingAllocation] fa WHERE fa.ReadId = r.readid AND status = 'Parked') FundingAllocationsParked,
		                                        COUNT(1)  OVER() as TotalRowsInTable
	                                        FROM [FundingAllocation].[FeedRead] r
	                                        WHERE r.ReadId <> 1
	                                        ORDER BY ROW_NUMBER() OVER(ORDER BY r.ReadId DESC)
	                                        OFFSET @startRow ROWS FETCH NEXT @numRows ROWS ONLY
END
GO

COMMIT;
GO


/*--------Consolidated-Payment-Report-Migration-Scripts---------------*/

--------------Type Payment summary ---------------

BEGIN TRANSACTION;
GO
IF NOT EXISTS (SELECT * FROM SYS.TYPES
WHERE is_user_defined = 1 AND Name IN ('PaymentMethodUDT'))    
    BEGIN
        CREATE TYPE [dbo].[PaymentMethodUDT] as Table
        (
        [PaymentMethod] int
        )
    END
    GO
COMMIT;
GO

------------------End Type---------------------

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetSubnominalValueInfromFromDb')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetSubnominalValueInfromFromDb]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetSubnominalValueInfromFromDb]
@paymentMethods [dbo].[PaymentMethodUDT] READONLY,
@year int,
@month int
AS
BEGIN
	select SUM(ISNULL(aggregatedvalue, 0)) as total,
                                          ag.ukprn,
		                                  org.TradingName,
		                                  activeFsp.name FundingStreamPeriodName,
										  AgencyPayment
										  
                                from [PaymentGeneration].[SubnominalAggregation] ag 
								INNER JOIN [PolicyCache].[PolicyFundingStreamCensusDate]  policyCensus ON ag.FundingStreamPeriodCode = policyCensus.FundingStreamPeriod 
								INNER JOIN [PolicyCache].[PolicyFundingStreamPeriod] activeFsp on policyCensus.FundingStreamPeriod=activeFsp.FundingStreamPeriod
								INNER JOIN [Organisation].[Organisation] org on ag.Ukprn=org.Ukprn								

								where (ActivityCloseDate is null or ActivityCloseDate > getDate())
			                        and activeFsp.PaymentMethod in (select PaymentMethod from @paymentMethods)
									and YEAR(policyCensus.CensusDate)=@year
									and MONTH(policyCensus.CensusDate)=@month
									and ag.Period=CONCAT(policyCensus.CalendarYear, format(policyCensus.CalendarPeriod, '0#'))
									and activeFsp.AgencyPayment IN ('DFE','DWP')
                                group by ag.ukprn, org.TradingName, activeFsp.name,AgencyPayment
END
GO

COMMIT;
GO




BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_Get1619SubnominalValueInfromFromDb')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_Get1619SubnominalValueInfromFromDb]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_Get1619SubnominalValueInfromFromDb]
@year int,
@month int
AS
BEGIN
SELECT 
    con.Ukprn AS ukprn,
    org.TradingName AS parenttradingName,
    dlyorg.Ukprn AS childukprn,
    dlyorg.TradingName AS childtradingName,
    fsp.FundingStreamPeriodCode AS fsp,
    SUM(sa.AggregatedValue) AS agencypayment1619,
    SUM(SUM(sa.AggregatedValue)) OVER (PARTITION BY con.ukprn) AS total1619,    
    ROW_NUMBER() OVER (
    PARTITION BY con.ukprn 
    ORDER BY 
        CASE WHEN con.ukprn = dlyorg.ukprn THEN 0 ELSE 1 END,
        fsp.FundingStreamPeriodCode,
        dlyorg.TradingName
) AS rowNum
FROM 
    PaymentGeneration.SubnominalAggregation sa
    JOIN PaymentSchedule.Allocation al ON sa.AllocationNumber = al.AllocationNumber AND sa.AllocationVersionNumber = al.ContractVersionNumber
    JOIN ContractManagement.ApprovedContract con ON al.ContractNumber = con.ContractNumber
    JOIN ContractManagement.ApprovedContract mcon ON con.ApprovedContractId = mcon.ApprovedContractId
    JOIN Organisation.Organisation org ON con.Ukprn = org.Ukprn
    JOIN Organisation.Organisation dlyorg ON dlyorg.Ukprn = sa.Ukprn
    JOIN ContractManagement.FundingStreamPeriod fsp ON fsp.FundingStreamPeriodCode = al.FundingStreamPeriodCode
WHERE 
    sa.Period = CONVERT(varchar(4), @year) + RIGHT('00' + CONVERT(varchar(2), @month), 2) 
    AND fsp.FundingStreamPeriodCode LIKE '%1619ED%' 
    AND con.ContractVersionNumber = (
        SELECT MAX(con2.ContractVersionNumber) 
        FROM ContractManagement.ApprovedContract con2 
        WHERE con2.ContractNumber = al.ContractNumber
    )
GROUP BY 
    dlyorg.Ukprn, dlyorg.TradingName, con.Ukprn, org.TradingName, fsp.FundingStreamPeriodCode
HAVING
 
 (con.Ukprn = dlyorg.Ukprn AND SUM(sa.AggregatedValue) <> 0)
    OR (con.Ukprn <> dlyorg.Ukprn AND SUM(sa.AggregatedValue) <> 0)

ORDER BY 
    org.TradingName, rowNum;
END
GO

COMMIT;
GO
/*------------------------------------------*END*-------------------------------------------*/
/*--------LA & Funding-Confirmation-Report-Migration-Scripts---------------*/
BEGIN TRANSACTION;
GO
IF NOT EXISTS (SELECT * FROM SYS.TYPES
WHERE is_user_defined = 1 AND Name IN ('FundingPeriodUDT'))     
    BEGIN
        CREATE TYPE [dbo].[FundingPeriodUDT] as Table
        (
        FundindPeriods varchar(50)
        )
    END
    GO
COMMIT;
GO
--------------*********---------------------------
BEGIN TRANSACTION;
GO
IF NOT EXISTS (SELECT * FROM SYS.TYPES
WHERE is_user_defined = 1 AND Name IN ('FspCodesUDT')) 
    BEGIN
        CREATE TYPE [dbo].[FspCodesUDT] as Table
        (
        FspCodes nvarchar(max)
        )
    END
    GO
COMMIT;
GO
--------------*********---------------------------
BEGIN TRANSACTION;
GO
IF NOT EXISTS (SELECT * FROM SYS.TYPES
WHERE is_user_defined = 1 AND Name IN ('UkprnsUDT'))     
    BEGIN
        CREATE TYPE [dbo].[UkprnsUDT] AS TABLE(
	    [Ukprn] [int] NULL
        )
    END
    GO
COMMIT;
GO
--------------*********---------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetFspInfos')  
                  BEGIN
                   DROP PROCEDURE [dbo].[sp_Operations_GetFspInfos] 
                  END
                  GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetFspInfos]
    @ukprnLst [dbo].[UkprnsUDT] READONLY,
	@startPeriod int,
	@endPeriod int
AS
BEGIN
    SELECT DISTINCT a.FundingStreamPeriodCode as FspCode, fspPolicy.Name as Description,fspPolicy.PaymentMethod,fspOp.[PeriodTypeCode],
CAST(row_number() OVER (ORDER BY  a.FundingStreamPeriodCode, fspPolicy.Name,fspPolicy.PaymentMethod,fspOp.[PeriodTypeCode]) AS INT)[Order]                                        
              FROM [PaymentSchedule].[DeliverablePayment] dp,
                   [PaymentSchedule].[Allocation] a,
            	   [PaymentSchedule].[OrganisationIdentifer] o,
            	   [PolicyCache].[PolicyDeliverable] d,
				   [PolicyCache].[PolicyFundingStreamPeriod] fspPolicy,
				   [Operations].[FundingStreamPeriod] fspOp	
              where dp.AllocationNumber = a.AllocationNumber
              and dp.VersionNumber = a.ContractVersionNumber
              and dp.VersionNumber = (select MAX (ContractVersionNumber)
                                      from  [PaymentSchedule].[Allocation] a
            						 where a.AllocationNumber = dp.AllocationNumber)
              and o.OrganisationId in (Select Ukprn from @ukprnLst)
              and o.AllocationNumber = a.AllocationNumber
              and o.VersionNumber = a.VersionNumber             
              and dp.DeliverableCode = d.DeliverableCode
              and a.FundingStreamPeriodCode = d.FundingStreamPeriod
			  and a.FundingStreamPeriodCode=fspPolicy.FundingStreamPeriod
			  and a.FundingStreamPeriodCode=fspOp.FundingStreamPeriodCode
			  and fspPolicy.FundingStreamPeriod=fspOp.FundingStreamPeriodCode
              and d.IsPayable = 1
              and dp.Period >= @startPeriod
              and dp.Period <= @endPeriod             
			  group by a.FundingStreamPeriodCode, fspPolicy.Name,fspPolicy.PaymentMethod,fspOp.[PeriodTypeCode]
END
GO
COMMIT;
GO
--------------*********---------------------------

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetUkprnsForPeriod') 
    BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetUkprnsForPeriod] 
    END
   GO  
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetUkprnsForPeriod]
   @startPeriod int,
   @endPeriod int
AS
BEGIN

    SELECT distinct(o.ukprn) Ukprn, o.Type Type, o.TradingName Name
                                 FROM [PaymentGeneration].[SubnominalAggregation] sa,
                                      [Organisation].[Organisation] o
                                where  sa.ukprn = o.Ukprn and sa.PostedFlag=1 and sa.Period>=@startPeriod and sa.Period<=@endPeriod
END
GO
COMMIT;
GO
--------------*********---------------------------

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetDeliverablePaymentInfosForPoP')
 BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetDeliverablePaymentInfosForPoP]
 END
 GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetDeliverablePaymentInfosForPoP]
    @fspCodes [dbo].[FspCodesUDT] READONLY,
    @startPeriod int,
	@endPeriod int
AS
BEGIN

  SELECT SUM(dp.PlannedValue) as ValueA,
	   SUM(dp.NetPaymentAmount) as ValueB,
	   o.OrganisationId as Ukprn,
	   a.FundingStreamPeriodCode as FspCode
  FROM [PaymentSchedule].[DeliverablePayment] dp JOIN
       [PaymentSchedule].[Allocation] a ON dp.AllocationNumber = a.AllocationNumber and dp.VersionNumber = a.ContractVersionNumber
  and dp.VersionNumber = (select MAX (ContractVersionNumber)
                          from  [PaymentSchedule].[Allocation] a
						 where a.AllocationNumber = dp.AllocationNumber)
  JOIN
	   [PaymentSchedule].[OrganisationIdentifer] o ON o.AllocationNumber = a.AllocationNumber and o.VersionNumber = a.VersionNumber and a.FundingStreamPeriodCode in (select FspCodes from @fspCodes) JOIN
	   [PolicyCache].[PolicyDeliverable] d  ON dp.DeliverableCode = d.DeliverableCode and a.FundingStreamPeriodCode = d.FundingStreamPeriod AND d.IsPayable = 1 
  WHERE dp.Period >= @startPeriod
  and dp.Period <= @endPeriod 
       
group by o.OrganisationId, a.FundingStreamPeriodCode
END
GO
COMMIT;
GO
--------------*********---------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetDeliverablePaymentInfosForPoAForAcademicYear')
     BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetDeliverablePaymentInfosForPoAForAcademicYear]
     END
     GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetDeliverablePaymentInfosForPoAForAcademicYear]
    @fspCodes [dbo].[FspCodesUDT] READONLY,
    @startPeriod int,
	@endPeriod int
AS
BEGIN
SELECT SUM(CASE WHEN d.AllowActuals = 1 THEN dp.ActualValue ELSE 0 END) as ValueA,
	   SUM(CASE WHEN d.AllowPayment = 1 THEN dp.NetPaymentAmount ELSE 0 END) as ValueB,
	   o.OrganisationId as Ukprn,
	   a.FundingStreamPeriodCode as FspCode
  FROM [PaymentSchedule].[DeliverablePayment] dp JOIN
       [PaymentSchedule].[Allocation] a ON dp.AllocationNumber = a.AllocationNumber and dp.VersionNumber = a.ContractVersionNumber
  and dp.VersionNumber = (select MAX (ContractVersionNumber)
                          from  [PaymentSchedule].[Allocation] a
						 where a.AllocationNumber = dp.AllocationNumber)
  JOIN
	   [PaymentSchedule].[OrganisationIdentifer] o ON o.AllocationNumber = a.AllocationNumber and o.VersionNumber = a.VersionNumber and a.FundingStreamPeriodCode in (Select FspCodes from @fspCodes) JOIN
	    [MonitoringDeliverables].[FundingStreamPeriodDeliverable] d  ON dp.DeliverableCode = d.DeliverableCode and a.FundingStreamPeriodCode = d.FundingStreamPeriodCode
  Where 
  dp.Period >= @startPeriod
  and dp.Period <= @endPeriod
group by o.OrganisationId, a.FundingStreamPeriodCode
END
GO
COMMIT;
GO
--------------*********---------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetDeliverablePaymentInfosForPoAForNonAcademicYear')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetDeliverablePaymentInfosForPoAForNonAcademicYear]
  END
  GO
COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE PROCEDURE [dbo].[sp_Operations_GetDeliverablePaymentInfosForPoAForNonAcademicYear]
    @fspCodes [dbo].[FspCodesUDT] READONLY,
	@startPeriod int,
	@endPeriod int
AS
BEGIN

SELECT SUM(CASE WHEN md.AllowActuals = 1 THEN dp.ActualValue ELSE 0 END) as ValueA,
	   SUM(CASE WHEN pd.AllowProfile = 1 THEN dp.PlannedValue ELSE 0 END) as ValueB,
	   o.OrganisationId as Ukprn,
	   a.FundingStreamPeriodCode as FspCode
  FROM [PaymentSchedule].[DeliverablePayment] dp
       inner join [PaymentSchedule].[Allocation] a
	   on dp.AllocationNumber = a.AllocationNumber and dp.VersionNumber = a.ContractVersionNumber   and dp.VersionNumber = (select MAX (ContractVersionNumber)
                          from  [PaymentSchedule].[Allocation] a
						 where a.AllocationNumber = dp.AllocationNumber)
	   inner join [PaymentSchedule].[OrganisationIdentifer] o
	   on dp.AllocationNumber = o.AllocationNumber and dp.VersionNumber = o.VersionNumber	   
	   left join [MonitoringDeliverables].[FundingStreamPeriodDeliverable] md
	   on a.FundingStreamPeriodCode = md.FundingStreamPeriodCode and dp.DeliverableCode = md.DeliverableCode
	   left join [PolicyCache].[PolicyDeliverable] pd
	   on a.FundingStreamPeriodCode = pd.FundingStreamPeriod and dp.DeliverableCode = pd.DeliverableCode
  where 
  o.AllocationNumber = a.AllocationNumber
  and o.VersionNumber = a.VersionNumber
  and a.FundingStreamPeriodCode in (select FspCodes from @fspCodes)
  and dp.Period >= @startPeriod
  and dp.Period <= @endPeriod
  group by o.OrganisationId, a.FundingStreamPeriodCode
END
GO
COMMIT;
GO
--------------*********---------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetNetPaymentInfosForPayOnInstruction')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetNetPaymentInfosForPayOnInstruction]
  END
  GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetNetPaymentInfosForPayOnInstruction]
    @fspCodes [dbo].[FspCodesUDT] READONLY,
	@startPeriod int,
	@endPeriod int
AS
BEGIN
SELECT SUM(dp.NetPaymentAmount) NetPayment,
	   o.OrganisationId as Ukprn,
	   a.FundingStreamPeriodCode as FspCode
  FROM 
   [PaymentSchedule].[DeliverablePayment] dp INNER JOIN [PaymentSchedule].[Allocation] a ON dp.AllocationNumber = a.AllocationNumber and dp.VersionNumber = a.ContractVersionNumber
  and dp.VersionNumber = (select MAX (ContractVersionNumber) from  [PaymentSchedule].[Allocation] a where a.AllocationNumber = dp.AllocationNumber)
  INNER JOIN [PaymentSchedule].[OrganisationIdentifer] o ON o.AllocationNumber = a.AllocationNumber and o.VersionNumber = a.VersionNumber and a.FundingStreamPeriodCode in (select FspCodes from  @fspCodes) 
  INNER JOIN [MonitoringDeliverables].[FundingStreamPeriodDeliverable] d  ON dp.DeliverableCode = d.DeliverableCode and a.FundingStreamPeriodCode = d.FundingStreamPeriodCode and d.AllowPayment = 1 and dp.Period >= @startPeriod
  and dp.Period <= @endPeriod  
  group by o.OrganisationId, a.FundingStreamPeriodCode
END
GO
COMMIT;
GO
--------------*********---------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetLAFspInfos')
 BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetLAFspInfos]
 END
 GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetLAFspInfos]
    @ukprnLst [dbo].[UkprnsUDT] READONLY,
	@startPeriod int,
	@endPeriod int
AS
BEGIN
SELECT DISTINCT a.FundingStreamPeriodCode as FspCode, fspPolicy.Name as Description,fspPolicy.PaymentMethod,fspOp.[PeriodTypeCode],
CAST(row_number() OVER (ORDER BY  a.FundingStreamPeriodCode, fspPolicy.Name,fspPolicy.PaymentMethod,fspOp.[PeriodTypeCode]) AS INT)[Order]                                        
              FROM [PaymentSchedule].[DeliverablePayment] dp,
                   [PaymentSchedule].[Allocation] a,
            	   [PaymentSchedule].[OrganisationIdentifer] o,
            	   [PolicyCache].[PolicyDeliverable] d,
				   [PolicyCache].[PolicyFundingStreamPeriod] fspPolicy,
				   [Operations].[FundingStreamPeriod] fspOp	
              where dp.AllocationNumber = a.AllocationNumber
              and dp.VersionNumber = a.ContractVersionNumber
              and dp.VersionNumber = (select MAX (ContractVersionNumber)
                                      from  [PaymentSchedule].[Allocation] a
            						 where a.AllocationNumber = dp.AllocationNumber)
              and o.OrganisationId in (Select Ukprn from @ukprnLst)
              and o.AllocationNumber = a.AllocationNumber
              and o.VersionNumber = a.VersionNumber             
              and dp.DeliverableCode = d.DeliverableCode
              and a.FundingStreamPeriodCode = d.FundingStreamPeriod
			  and a.FundingStreamPeriodCode=fspPolicy.FundingStreamPeriod
			  and a.FundingStreamPeriodCode=fspOp.FundingStreamPeriodCode
			  and fspPolicy.FundingStreamPeriod=fspOp.FundingStreamPeriodCode
              and d.IsPayable = 1
              and dp.Period >= @startPeriod
              and dp.Period <= @endPeriod             
			  group by a.FundingStreamPeriodCode, fspPolicy.Name,fspPolicy.PaymentMethod,fspOp.[PeriodTypeCode]
END
GO
COMMIT;
GO
--------------*********---------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetLADeliverablePaymentInfosForPoP')
 BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetLADeliverablePaymentInfosForPoP]
 END
 GO
 COMMIT;
GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetLADeliverablePaymentInfosForPoP]
    @ukprnLst [dbo].[UkprnsUDT] READONLY,
	@fspCodes [dbo].[FspCodesUDT] READONLY,
	@startPeriod int,
	@endPeriod int
AS
BEGIN
SELECT SUM(dp.PlannedValue) as ValueA,
	   SUM(dp.NetPaymentAmount) as ValueB,
	   o.OrganisationId as Ukprn,
	   a.FundingStreamPeriodCode as FspCode
  FROM [PaymentSchedule].[DeliverablePayment] dp,
       [PaymentSchedule].[Allocation] a,
	   [PaymentSchedule].[OrganisationIdentifer] o,
	   [PolicyCache].[PolicyDeliverable] d
  where dp.AllocationNumber = a.AllocationNumber
  and dp.VersionNumber = a.ContractVersionNumber
  and dp.VersionNumber = (select MAX (ContractVersionNumber)
                          from  [PaymentSchedule].[Allocation] a
						 where a.AllocationNumber = dp.AllocationNumber)
  and o.OrganisationId in (Select Ukprn from @ukprnLst)
  and o.AllocationNumber = a.AllocationNumber
  and o.VersionNumber = a.VersionNumber
  and a.FundingStreamPeriodCode in (Select FspCodes from @fspCodes)
  and dp.DeliverableCode = d.DeliverableCode
  and a.FundingStreamPeriodCode = d.FundingStreamPeriod
  and d.IsPayable = 1
  and dp.Period >= @startPeriod
  and dp.Period <= @endPeriod 
  group by o.OrganisationId, a.FundingStreamPeriodCode
  END
  GO
  COMMIT;
GO
--------------*********---------------------------
  BEGIN TRANSACTION;
  GO
  IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetLADeliverablePaymentInfosForPoAForFinancialYear')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetLADeliverablePaymentInfosForPoAForFinancialYear]
  END
  GO

  COMMIT;
  GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetLADeliverablePaymentInfosForPoAForFinancialYear]
    @ukprnLst [dbo].[UkprnsUDT] READONLY,
	@fspCodes [dbo].[FspCodesUDT] READONLY,
	@startPeriod int,
	@endPeriod int
AS
BEGIN
SELECT SUM(CASE WHEN d.AllowActuals = 1 THEN dp.ActualValue ELSE 0 END) as ValueA,
            	   SUM(CASE WHEN d.AllowPayment = 1 THEN dp.NetPaymentAmount ELSE 0 END) as ValueB,
            	   o.OrganisationId as Ukprn,
            	   a.FundingStreamPeriodCode as FspCode
              FROM [PaymentSchedule].[DeliverablePayment] dp,
                   [PaymentSchedule].[Allocation] a,
            	   [PaymentSchedule].[OrganisationIdentifer] o,
            	   [MonitoringDeliverables].[FundingStreamPeriodDeliverable] d
              where dp.AllocationNumber = a.AllocationNumber
              and dp.VersionNumber = a.ContractVersionNumber
              and dp.VersionNumber = (select MAX (ContractVersionNumber)
                                      from  [PaymentSchedule].[Allocation] a
            						 where a.AllocationNumber = dp.AllocationNumber)
              and o.OrganisationId in (Select Ukprn from @ukprnLst)
              and o.AllocationNumber = a.AllocationNumber
              and o.VersionNumber = a.VersionNumber
              and a.FundingStreamPeriodCode in (select FspCodes from @fspCodes)
              and dp.DeliverableCode = d.DeliverableCode
              and a.FundingStreamPeriodCode = d.FundingStreamPeriodCode
              and dp.Period >= @startPeriod
              and dp.Period <= @endPeriod
              group by o.OrganisationId, a.FundingStreamPeriodCode
  END
  GO
  COMMIT;
GO
  --------------*********---------------------------
  BEGIN TRANSACTION;
  GO
  IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetLADeliverablePaymentInfosForPoAForALAPNLAP')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetLADeliverablePaymentInfosForPoAForALAPNLAP]
  END
  GO
  COMMIT;
  GO

  BEGIN TRANSACTION;
  GO
  CREATE PROCEDURE [dbo].[sp_Operations_GetLADeliverablePaymentInfosForPoAForALAPNLAP]
    @ukprnLst [dbo].[UkprnsUDT] READONLY,
	@fspCodes [dbo].[FspCodesUDT] READONLY,
	@startPeriod int,
	@endPeriod int
AS
BEGIN
SELECT SUM(CASE WHEN d.AllowActuals = 1 THEN dp.ActualValue ELSE 0 END) as ValueA,
            	   SUM(CASE WHEN d.AllowPayment = 1 THEN dp.NetPaymentAmount ELSE 0 END) as ValueB,
            	   o.OrganisationId as Ukprn,
            	   a.FundingStreamPeriodCode as FspCode
              FROM [PaymentSchedule].[DeliverablePayment] dp,
                   [PaymentSchedule].[Allocation] a,
            	   [PaymentSchedule].[OrganisationIdentifer] o,
            	   [MonitoringDeliverables].[FundingStreamPeriodDeliverable] d
              where dp.AllocationNumber = a.AllocationNumber
              and dp.VersionNumber = a.ContractVersionNumber
              and dp.VersionNumber = (select MAX (ContractVersionNumber)
                                      from  [PaymentSchedule].[Allocation] a
            						 where a.AllocationNumber = dp.AllocationNumber)
              and o.OrganisationId in (Select Ukprn from @ukprnLst)
              and o.AllocationNumber = a.AllocationNumber
              and o.VersionNumber = a.VersionNumber
              and a.FundingStreamPeriodCode in (Select FspCodes from @fspCodes)
              and dp.DeliverableCode = d.DeliverableCode
              and a.FundingStreamPeriodCode = d.FundingStreamPeriodCode
              and dp.Period >= @startPeriod
              and dp.Period <= @endPeriod
              group by o.OrganisationId, a.FundingStreamPeriodCode
  END
  GO
  COMMIT;
GO
--------------*********---------------------------
BEGIN TRANSACTION;
GO
  IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetLANetPaymentInfosForPayOnInstruction')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetLANetPaymentInfosForPayOnInstruction]
  END
  GO
  COMMIT;
  GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetLANetPaymentInfosForPayOnInstruction]
    @ukprnLst [dbo].[UkprnsUDT] READONLY,
	@fspCodes [dbo].[FspCodesUDT] READONLY,
	@startPeriod int,
	@endPeriod int
AS
BEGIN
SELECT SUM(dp.NetPaymentAmount) NetPayment,
            	   o.OrganisationId as Ukprn,
            	   a.FundingStreamPeriodCode as FspCode
              FROM [PaymentSchedule].[DeliverablePayment] dp,
                   [PaymentSchedule].[Allocation] a,
            	   [PaymentSchedule].[OrganisationIdentifer] o,
            	   [MonitoringDeliverables].[FundingStreamPeriodDeliverable] d
              where dp.AllocationNumber = a.AllocationNumber
              and dp.VersionNumber = a.ContractVersionNumber
              and dp.VersionNumber = (select MAX (ContractVersionNumber)
                                      from  [PaymentSchedule].[Allocation] a
            						 where a.AllocationNumber = dp.AllocationNumber)
              and o.OrganisationId in (Select Ukprn from @ukprnLst)
              and o.AllocationNumber = a.AllocationNumber
              and o.VersionNumber = a.VersionNumber
              and a.FundingStreamPeriodCode in (Select FspCodes from @fspCodes)
              and dp.DeliverableCode = d.DeliverableCode
              and a.FundingStreamPeriodCode = d.FundingStreamPeriodCode
              and d.AllowPayment = 1
              and dp.Period >= @startPeriod
              and dp.Period <= @endPeriod
              group by o.OrganisationId, a.FundingStreamPeriodCode
  END
  GO

COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetLAUkprnsForPeriod')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetLAUkprnsForPeriod]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operations_GetLAUkprnsForPeriod]
@startPeriod int,
@endPeriod int
AS
BEGIN

SELECT distinct sa.Ukprn,o.Type, o.TradingName Name from PaymentGeneration.SubnominalAggregation sa INNER JOIN [Organisation].[Organisation] o on  sa.ukprn = o.Ukprn 
where sa.Period>=@startPeriod and sa.Period<=@endPeriod and IsSelectedForPayment=1 and o.Type like '%school%' or o.type like '%Local Authority%' or o.Type like '%Academy%'

END
GO

COMMIT;
GO

/*------------------------------------------*END LA & College Report Migration Scripts*-------------------------------------------*/


------------ *Operation-Integrity Check*----------------------------------------
BEGIN TRANSACTION;
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetAllocationVersionAtCollectionReturn')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetAllocationVersionAtCollectionReturn]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetAllocationVersionAtCollectionReturn]
@allocationNumber nvarchar(50),
@collectionType nvarchar(50),
@collectionReturnCode nvarchar(50)
AS
BEGIN

SELECT TOP (1) [ContractVersion]
                                  FROM  [MonitoringDeliverables].[AllocationDeliverablePeriodActualAudit]
                                  WHERE [ContractAllocationNumber] = @allocationNumber
                                  AND   [CollectionType] = @collectionType
                                  AND   [CollectionReturnCode] = @collectionReturnCode
END
GO


IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetFundingStreamPeriod')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetFundingStreamPeriod]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetFundingStreamPeriod]
@fundingStreamPeriodCode nvarchar(50)
AS
BEGIN

select [Code]
                                       ,[Name]
                                       ,[ProcessFutureActuals]
                                       ,[PersistCurrentActualsState]
                                       ,[ZeroiseMissingActuals]
                                       ,[PaymentMethod]
                                       ,[ActivityCloseDate]
                                       ,[MultiCollectionReturns] 
                                 from [MonitoringDeliverables].[FundingStreamPeriod]
                                 where Code = @fundingStreamPeriodCode
END
GO


IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_IsFundingStreamPeriodPayOnInstruction')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_IsFundingStreamPeriodPayOnInstruction]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_IsFundingStreamPeriodPayOnInstruction]
@fspCode NVARCHAR(50)
AS
BEGIN

select PaymentMethod from [MonitoringDeliverables].[FundingStreamPeriod]
                                 where Code = @fspCode
END
GO



IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetFundingStreamPeriodCodesThatAreActive')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetFundingStreamPeriodCodesThatAreActive]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetFundingStreamPeriodCodesThatAreActive]
@date DATETIME
AS
BEGIN

select Code from [MonitoringDeliverables].[FundingStreamPeriod]
                                 where (ActivityCloseDate is null or ActivityCloseDate >= @date)
END
GO


IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetEntityFromDatabase')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetEntityFromDatabase]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetEntityFromDatabase]
@allocationNumber nvarchar(50)
AS
BEGIN

select [TerminationDate]
                                 from [MonitoringDeliverables].[AllocationUnderTermination]
                                 where ContractAllocationNumber = @allocationNumber
END
GO


IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetActiveAllocationDeliverablePeriods')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetActiveAllocationDeliverablePeriods]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetActiveAllocationDeliverablePeriods]
@organisationId nvarchar(50),
@fundingStreamPeriodCode nvarchar(50),
@uopCode nvarchar(50)
AS
BEGIN
SELECT [OrganisationId]
      ,[FundingStreamPeriodCode]
      ,[UopCode]
      ,[DeliverableCode]
      ,[Period]
      ,[ContractAllocationNumber]
      ,[ContractNumber]
      ,[ContractVersionNumber]
      ,[ContractSubVersionNumber]
      ,[AllocationStartDate]
      ,[AllocationEndDate]
      ,[Ukprn]
      ,[CreatedDate]
      ,[Id]
  FROM [MonitoringDeliverables].[AllocationDeliverablePeriod]
  where ContractAllocationNumber not in (select ContractAllocationNumber from [MonitoringDeliverables].[InactiveAllocation])
  and OrganisationId = @organisationId
  and FundingStreamPeriodCode = @fundingStreamPeriodCode
  and UopCode = @uopCode
END
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetCollectionReturns')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetCollectionReturns]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetCollectionReturns]
@multipleCollectionGroupId int,
@collectionType nvarchar(50),
@collectionReturnCode nvarchar(50)
AS
BEGIN
select CollectionType,
                         CollectionReturnCode
                  from [MonitoringDeliverables].[HeldFspCollectionConfig]
                  where [MultipleCollectionGroupId] = @multipleCollectionGroupId
                  and [CollectionType] = @collectionType
                  and [CollectionReturnCode] = @collectionReturnCode
END
GO


IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetMultipleCollectionGroupId')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetMultipleCollectionGroupId]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetMultipleCollectionGroupId]
@fundingStreamPeriodCode nvarchar(50),
@collectionType nvarchar(50),
@collectionReturnCode nvarchar(50)
AS
BEGIN
select MultipleCollectionGroupId 
                  from [MonitoringDeliverables].[HeldFspCollectionConfig]
                  where [FundingStreamPeriodCode] = @fundingStreamPeriodCode
                  and [CollectionType] = @collectionType
                  and [CollectionReturnCode] = @collectionReturnCode
END
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_IsCollectionReturnPresent')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_IsCollectionReturnPresent]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_IsCollectionReturnPresent]
@collectionType nvarchar(50),
@collectionReturnCode nvarchar(50)
AS
BEGIN
SELECT COUNT(1) 
                  FROM MonitoringDeliverables.ClosedCollection 
                  WHERE CollectionType = @collectionType 
                  AND CollectionReturnCode = @collectionReturnCode
END
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetLatestCollectionCodeForCollectionType')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetLatestCollectionCodeForCollectionType]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetLatestCollectionCodeForCollectionType]
@collectionType nvarchar(50)
AS
BEGIN
SELECT TOP 1 CollectionReturnCode 
                  FROM MonitoringDeliverables.ClosedCollection 
                  WHERE CollectionType = @collectionType 
                  ORDER BY CollectionReturnCode DESC
END
GO

IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetLastClosedTime')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetLastClosedTime]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetLastClosedTime]
@collectionType nvarchar(50)
AS
BEGIN
SELECT TOP 1 ClosedTime 
                  FROM MonitoringDeliverables.ClosedCollection 
                  WHERE CollectionType = @collectionType 
                  ORDER BY ClosedTime DESC
END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF NOT EXISTS (SELECT * FROM SYS.TYPES
WHERE is_user_defined = 1 AND Name IN ('AllocationNumbersUDT')) 
    BEGIN
        CREATE TYPE [dbo].[AllocationNumbersUDT] as Table
        (
        AllocationNumbers nvarchar(max)
        )
    END
    GO
COMMIT;
GO



BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetActiveAllocationDeliverablePeriodsbyAllocation') 
    BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetActiveAllocationDeliverablePeriodsbyAllocation] 
    END
   GO  
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetActiveAllocationDeliverablePeriodsbyAllocation]
    @allocationNumbers [dbo].[AllocationNumbersUDT] READONLY 
AS
BEGIN

SELECT [OrganisationId]
      ,[FundingStreamPeriodCode]
      ,[UopCode]
      ,[DeliverableCode]
      ,[Period]
      ,[ContractAllocationNumber]
      ,[ContractNumber]
      ,[ContractVersionNumber]
      ,[ContractSubVersionNumber]
      ,[AllocationStartDate]
      ,[AllocationEndDate]
      ,[Ukprn]
      ,[CreatedDate]
      ,[Id]
  FROM [MonitoringDeliverables].[AllocationDeliverablePeriod]
  where ContractAllocationNumber not in (select ContractAllocationNumber from [MonitoringDeliverables].[InactiveAllocation])
  and ContractAllocationNumber in (Select AllocationNumbers from @allocationNumbers)

END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetData') 
    BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetData] 
    END
   GO  
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
CREATE PROCEDURE [dbo].[sp_Operations_GetData]
    @fspCodes [dbo].[FspCodesUDT] READONLY
AS
BEGIN
  SELECT
	sa.AllocationNumber,
	sa.Period,
    sa.SubnominalCode,
    sa.PaymentType,
	sa.AggregatedValue,
    CASE WHEN ia.ContractAllocationNumber IS NULL THEN 0 ELSE 1 END IsInactiveContract
FROM
	PaymentGeneration.SubnominalAggregation sa
    LEFT JOIN MonitoringDeliverables.InactiveAllocation ia ON ia.ContractAllocationNumber = sa.AllocationNumber 
WHERE
	FundingStreamPeriodCode IN (select FspCodes from  @fspCodes) 
END
GO
COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetSummarisedActualOrgFspGroupKeys')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetSummarisedActualOrgFspGroupKeys]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetSummarisedActualOrgFspGroupKeys]
@collectionType nvarchar(50),
@collectionReturnCode nvarchar(50)
AS
BEGIN
select distinct  [CollectionType],
                                [CollectionReturnCode],
                                [OrganisationId],
                                [FundingStreamPeriodCode],
                                [UopCode]
                                from [MonitoringDeliverables].[SummarisedActual]
                                where CollectionType = @collectionType
                                and CollectionReturnCode = @collectionReturnCode
END
GO
COMMIT;
GO

----------------------------------------*END-Integrity-Check*------------------------------------------
----------------------------------------*CDA Report*---------------------------------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetAllCdaExtracts')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetAllCdaExtracts]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetAllCdaExtracts]
@todayDate DATETIME
AS
BEGIN
select cda.ExtractName,
                                        cda.ReportingCloseDate,
                                        cdaFsp.FundingStreamPeriodCode,
                                        cda.ArchiveClosedContracts
                                 from [ContractManagement].[CdaExtract] cda,
                                      [ContractManagement].[CdaReportFundingStreamPeriod] cdaFsp
                                 where cda.ExtractName = cdaFsp.ExtractName
                                 and ISNULL(cda.ReportingCloseDate, @todayDate) >= @todayDate
END
GO
COMMIT;
GO
-------------------------------------------------******----------------------------------------------

----------------------------------------*Connectivity Checker*---------------------------------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_InsertOrUpdateConnectivity')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_InsertOrUpdateConnectivity]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operations_InsertOrUpdateConnectivity]
@serviceName nvarchar(50),
@canConnect bit,
@ErrorInfo nvarchar(500),
@supplementaryInfo nvarchar(500)


AS
BEGIN
MERGE INTO [Operations].[Connectivity] AS Target
                                       USING (VALUES (@serviceName)) AS source (id)
                                        ON Target.ServiceName = Source.Id
                                       WHEN MATCHED THEN
                                            UPDATE 
                                               SET TARGET.[CanConnect] = @canConnect
                                                  ,[ErrorInfo] = @errorInfo
                                                  ,[SupplementaryInfo] = @supplementaryInfo
                                                  ,[LastUpdated] = GETUTCDATE()
                                       WHEN NOT MATCHED BY TARGET THEN
                                             INSERT 
                                                   ([ServiceName]
                                                   ,[CanConnect]
                                                   ,[ErrorInfo]
                                                   ,[SupplementaryInfo]
                                                   ,[LastUpdated])
                                             VALUES
                                                   (@serviceName
                                                   ,@canConnect
                                                   ,@errorInfo
                                                   ,@supplementaryInfo
                                                   ,GETUTCDATE());
END
GO
COMMIT;
GO
-------------------------------------------------******----------------------------------------------

----------------------------------------*Extract*---------------------------------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operations_GetExtract')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operations_GetExtract]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operations_GetExtract]
@extractTypeString nvarchar(50)

AS
BEGIN
select *,
           (select ct.ContractType from [FundingAllocation].CfsCodesToContractTypeConfig ct
          where  ct.FundingPeriodCode = fa.FundingPeriodCode
          and ct.FundingTypeCode = fa.FundingTypeCode
          and ct.ProviderCategory = fa.providerCategory) as contractTypeUsingProviderCategory,
         (select ct.ContractType from [FundingAllocation].CfsCodesToContractTypeConfig ct
          where  ct.FundingPeriodCode = fa.FundingPeriodCode
          and ct.FundingTypeCode = fa.FundingTypeCode
          and ct.ProviderCategory = 'DEFAULT') as contractTypeUsingDefault
    from (
    select *,
     ISNULL(providerCategoryException, providerCategoryDefault) as providerCategory
      from 
    (SELECT  pi.lastParked, pi.lastDiscarded,
		    fa.fundingId,
		    fa.ukprn,
		    pf.providerType,
		    pf.providerSubType,
		    fa.allocationFundingStream,
		    fa.period,
		    fa.fundingVersion,
		    fa.value,
		    o.tradingName,
		    afsc.fundingPeriodCode,
		    afsc.fundingTypeCode,
		    afsc.fspGroupCode,
		    (SELECT [Category]
				      FROM [FundingAllocation].[ProviderCategoryException]
				      WHERE [FundingTypeCode] = afsc.FundingTypeCode
				      AND [FundingPeriodCode] = afsc.FundingPeriodCode
				      AND [UKPRN] = fa.UKPRN) as providerCategoryException,
	        (SELECT [Category]
				      FROM [FundingAllocation].[ProviderTypeConfig]
				      WHERE [Type] = pf.ProviderType
				      AND [Subtype] = pf.ProviderSubType) providerCategoryDefault,
            fa.status,
            fa.subStatus

   from [FundingAllocation].[FundingAllocation] fa
   JOIN [FundingAllocation].ParkingAndDiscardedInfo pi on fa.FundingId = pi.FundingAllocationId
   LEFT JOIN [Organisation].[Organisation] o ON fa.ukprn = o.Ukprn
   CROSS APPLY (select 
							TOP(1) pf.ProviderSubType, pf.ProviderType, pfa.FundingId
					  from [FundingAllocation].[ProviderFunding] pf,
						   [FundingAllocation].[ProviderFundingAllocation] pfa
				      where pf.ProviderFundingId = pfa.ProviderFundingId
					  and fa.FundingId = pfa.FundingId) pf
    LEFT JOIN [FundingAllocation].[AllocationFundingStreamConfig] afsc on fa.AllocationFundingStream = afsc.AllocationFundingStreamCode and fa.Period = afsc.AllocationPeriodId
		     
    where fa.Status = @extractTypeString) t) fa
END
GO
COMMIT;
GO
-------------------------------------------------******----------------------------------------------
BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetSummarisedActualsForCollectionTypeAndReturnCode')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetSummarisedActualsForCollectionTypeAndReturnCode]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetSummarisedActualsForCollectionTypeAndReturnCode]
@collectionType nvarchar(50),
@collectionReturnCode nvarchar(50)
AS
BEGIN
select [Id]
                              ,[OrganisationId]
                              ,[FundingStreamPeriodCode]
                              ,[UopCode]
                              ,[Period]
                              ,[DeliverableCode]
                              ,[ContractAllocationNumber]
                              ,[ActualVolume]
                              ,[ActualValue]
                              ,[DataCollectionsId]
                              ,[CreatedDate]
                          from [MonitoringDeliverables].[SummarisedActual]
                          where
                               [CollectionType] = @CollectionType and
                               [CollectionReturnCode] = @CollectionReturnCode
END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_Operation_GetActiveAllocationDeliverablePeriods')
  BEGIN
     DROP PROCEDURE [dbo].[sp_Operation_GetActiveAllocationDeliverablePeriods]
  END

GO
CREATE PROCEDURE [dbo].[sp_Operation_GetActiveAllocationDeliverablePeriods]
@OrganisationId nvarchar(10),
@FundingStreamPeriodCode nvarchar(100),
@UopCode nvarchar(100)
AS
BEGIN
SELECT TOP (1000) [OrganisationId]
                                                  ,[FundingStreamPeriodCode]
                                                  ,[UopCode]
                                                  ,[DeliverableCode]
                                                  ,[Period]
                                                  ,[ContractAllocationNumber]
                                                  ,[ContractNumber]
                                                  ,[ContractVersionNumber]
                                                  ,[ContractSubVersionNumber]
                                                  ,[AllocationStartDate]
                                                  ,[AllocationEndDate]
                                                  ,[Ukprn]
                                                  ,[Id]
                                              FROM [MonitoringDeliverables].[AllocationDeliverablePeriod]
                                             WHERE [OrganisationId] = @OrganisationId
                                               AND [FundingStreamPeriodCode] = @FundingStreamPeriodCode
                                               AND [UopCode] = @UopCode
END
GO
COMMIT;
GO


