BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_CfsCodesToContractTypeConfigInsert')
  BEGIN
     DROP PROCEDURE [dbo].[sp_CfsCodesToContractTypeConfigInsert]
  END

GO
CREATE PROCEDURE [dbo].[sp_CfsCodesToContractTypeConfigInsert]
    @fundingTypeCode nvarchar(50),
  @fundingPeriodCode nvarchar(50),
  @providerCategory nvarchar(50),
  @contractType nvarchar(100)
AS
BEGIN

   INSERT INTO [FundingAllocation].[CfsCodesToContractTypeConfig]
                                     ([FundingTypeCode]
                                     ,[FundingPeriodCode]
                                     ,[ProviderCategory]
                                     ,[ContractType])
                                     VALUES
                                      (@fundingTypeCode,
                                       @fundingPeriodCode,
                                       @providerCategory,
                                       @contractType)

END
GO
COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_InsertDasEvent')
  BEGIN
     DROP PROCEDURE [dbo].[sp_InsertDasEvent]
  END

GO
CREATE PROCEDURE [dbo].[sp_InsertDasEvent]
      @eventId bigint,
	@ukprn nvarchar(10)

AS
BEGIN

  insert into [ContractManagement].[EngagementEvent] ([EventId]
                                    ,[EventType]
                                    ,[ProviderId]
                                    ,[ProcessingState]) values (@eventId, 'INITIATED', @ukprn, 5);

END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_OverrideDateSetDate')
  BEGIN
     DROP PROCEDURE [dbo].[sp_OverrideDateSetDate]
  END

GO
CREATE PROCEDURE [dbo].[sp_OverrideDateSetDate]
 @date DateTime
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

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_ProviderCategoryExceptionInsert')
  BEGIN
     DROP PROCEDURE [dbo].[sp_ProviderCategoryExceptionInsert]
  END

GO
CREATE PROCEDURE [dbo].[sp_ProviderCategoryExceptionInsert]
 @fundingTypeCode nvarchar(50),
  @fundingPeriodCode nvarchar(50),
  @ukprn nvarchar(10),
  @category nvarchar(50)
AS
BEGIN
INSERT INTO [FundingAllocation].[ProviderCategoryException]
                                            (FundingTypeCode, FundingPeriodCode, UKPRN, Category)
                                          VALUES (@fundingTypeCode, @fundingPeriodCode, @ukprn, @category)
END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_ProviderCategoryExceptionInsert')
  BEGIN
     DROP PROCEDURE [dbo].[sp_ProviderCategoryExceptionInsert]
  END

GO
CREATE PROCEDURE [dbo].[sp_ProviderCategoryExceptionInsert]
 @fundingTypeCode nvarchar(50),
  @fundingPeriodCode nvarchar(50),
  @ukprn nvarchar(10),
  @category nvarchar(50)
AS
BEGIN
INSERT INTO [FundingAllocation].[ProviderCategoryException]
                                            (FundingTypeCode, FundingPeriodCode, UKPRN, Category)
                                          VALUES (@fundingTypeCode, @fundingPeriodCode, @ukprn, @category)
END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_ProviderTypeConfig')
  BEGIN
     DROP PROCEDURE [dbo].[sp_ProviderTypeConfig]
  END

GO
CREATE PROCEDURE [dbo].[sp_ProviderTypeConfig]
  @type nvarchar(50),
  @subType nvarchar(50),
  @category nvarchar(50)
AS
BEGIN
INSERT INTO [FundingAllocation].[ProviderTypeConfig]
                                     ([Type]
                                     ,[SubType]
                                     ,[Category])
                                     VALUEs
                                     (@type,
                                      @subType,
                                      @category)
END
GO
COMMIT;
GO



BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_RemoveContractbyMontDelNo')
  BEGIN
     DROP PROCEDURE [dbo].[sp_RemoveContractbyMontDelNo]
  END

GO
CREATE PROCEDURE [dbo].[sp_RemoveContractbyMontDelNo]
@schema NVARCHAR(30),
 @table NVARCHAR(MAX),
 @contractNumber nvarchar(50)

AS
Begin
set nocount off;
    declare @trancount int;
    set @trancount = @@trancount;
    begin try
        if @trancount = 0
            begin transaction
        else
            save transaction sp_RemoveContractbyMontDelNo;
       DECLARE @Sql NVARCHAR(Max)      
	  
		        SET @Sql='DELETE FROM '+ QUOTENAME(@schema)+'.'+ QUOTENAME(@table)+' where ContractNumber = '+''''+@contractNumber+''''
			
				EXECUTE sp_executesql @Sql
				return @@ROWCOUNT 
			
lbexit:
        if @trancount = 0
            commit;
    end try
    begin catch
        declare @error int, @message varchar(4000), @xstate int;
        select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();
        if @xstate = -1
            rollback;
        if @xstate = 1 and @trancount = 0
            rollback
        if @xstate = 1 and @trancount > 0
            rollback transaction usp_my_procedure_name;

        raiserror ('sp_RemoveContractbyMontDelNo: %d: %s', 16, 1, @error, @message) ;
    end catch
end
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_RemoveCreatedContract')
  BEGIN
     DROP PROCEDURE [dbo].[sp_RemoveCreatedContract]
  END

GO
CREATE PROCEDURE [dbo].[sp_RemoveCreatedContract]
   @contractNumber nvarchar(50),
   @contractVersionNumber int,
   @contractSubVersionNumber int
AS
BEGIN

       DELETE  FROM [ContractManagement].[CreatedContract]
                                     WHERE [ContractNumber] = @contractNumber
                                     AND   [ContractVersionNumber] = @contractVersionNumber
                                     AND   [ContractSubVersionNumber] = @contractSubVersionNumber
END
GO
COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_RoatpProviderAddRange')
  BEGIN
     DROP PROCEDURE [dbo].[sp_RoatpProviderAddRange]
  END

GO
CREATE PROCEDURE [dbo].[sp_RoatpProviderAddRange]
   @ukprnsFormatted nvarchar(100)
AS
BEGIN TRY
    BEGIN TRAN T1;
		DECLARE @inputValues TABLE(inputUkprn NVARCHAR(10))
                    INSERT @inputValues VALUES (@ukprnsFormatted)
                    INSERT [ContractManagement].[RoatpProvider] ([Ukprn])
                    SELECT inputUkprn FROM @inputValues
                    WHERE [inputUkprn] NOT IN
        	            (SELECT [Ukprn] FROM [ContractManagement].[RoatpProvider])
    COMMIT TRAN T1;
END TRY
BEGIN CATCH
        ROLLBACK TRAN T1;
END CATCH
GO
COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_RoatpProviderRemoveRange')
  BEGIN
     DROP PROCEDURE [dbo].[sp_RoatpProviderRemoveRange]
  END

GO
CREATE PROCEDURE [dbo].[sp_RoatpProviderRemoveRange]
   @ukprnsFormatted nvarchar(100)
AS
BEGIN TRY
    BEGIN TRAN T1;
		DECLARE @inputValues TABLE(inputUkprn NVARCHAR(10))
                    INSERT @inputValues VALUES (@ukprnsFormatted)
                    DELETE FROM [ContractManagement].[RoatpProvider]
                    WHERE Ukprn IN (SELECT [inputUkprn] FROM @inputValues)
    COMMIT TRAN T1;
END TRY
BEGIN CATCH
        ROLLBACK TRAN T1;
END CATCH
COMMIT;
GO



BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_ToolingStepsGetLowestDasEventId')
  BEGIN
     DROP PROCEDURE [dbo].[sp_ToolingStepsGetLowestDasEventId]
  END

GO
CREATE PROCEDURE [dbo].[sp_ToolingStepsGetLowestDasEventId]
AS
BEGIN

      Select TOP 1 EventId from [ContractManagement].[EngagementEvent] order by EventId
END
GO
COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_UpdateCreatedContractCreatedDate')
  BEGIN
     DROP PROCEDURE [dbo].[sp_UpdateCreatedContractCreatedDate]
  END

GO
CREATE PROCEDURE [dbo].[sp_UpdateCreatedContractCreatedDate]
 @createdDate datetime,
    @contractNumber nvarchar(50),
    @contractVersionNumber int,
    @contractSubVersionNumber int
AS
BEGIN

    Update [ContractManagement].[CreatedContract]
                                     set CreatedDate = @createdDate
                                     where [ContractNumber] = @contractNumber
                                     and [ContractVersionNumber] = @contractVersionNumber
                                     and [ContractSubVersionNumber] = @contractSubVersionNumber

END
GO
COMMIT;
GO



BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_AddCreatedContractOrUpdate')
  BEGIN
     DROP PROCEDURE [dbo].[sp_AddCreatedContractOrUpdate]
  END

GO
CREATE PROCEDURE [dbo].[sp_AddCreatedContractOrUpdate]
  @contractNumber nvarchar(50),
   @contractVersionNumber int,
   @contractSubVersionNumber int,
   @createdDate datetime
AS
BEGIN

     INSERT INTO [ContractManagement].[CreatedContract] ([ContractNumber] , [ContractVersionNumber], [ContractSubVersionNumber], [CreatedDate])
         VALUES (@contractNumber, @contractVersionNumber, @contractSubVersionNumber, @createdDate)

END
GO
COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_AllocationFundingStreamConfigInsert')
  BEGIN
     DROP PROCEDURE [dbo].[sp_AllocationFundingStreamConfigInsert]
  END

GO
CREATE PROCEDURE [dbo].[sp_AllocationFundingStreamConfigInsert]
   @allocationFundingStreamCode nvarchar(50),
  @allocationPeriodId nvarchar(50),
  @fundingTypeCode nvarchar(50),
  @fundingPeriodCode nvarchar(50),
  @fspGroupCode nvarchar(50)
AS
BEGIN

   INSERT INTO [FundingAllocation].[AllocationFundingStreamConfig]
                                     (allocationFundingStreamCode,
                                      allocationPeriodId,
                                      fundingTypeCode,
                                      fundingPeriodCode,
                                      fspGroupCode)
                                     VALUES
                                      (@allocationFundingStreamCode,
                                       @allocationPeriodId,
                                       @fundingTypeCode,
                                       @fundingPeriodCode,
                                       @fspGroupCode)

END
GO
COMMIT;
GO



BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_AllocationLineConfigInsert')
  BEGIN
     DROP PROCEDURE [dbo].[sp_AllocationLineConfigInsert]
  END

GO
CREATE PROCEDURE [dbo].[sp_AllocationLineConfigInsert]
   @fundingStreamCode nvarchar(50),
  @periodId nvarchar(50),
  @fundingLineCode nvarchar(50),
  @providerCategory nvarchar(50),
  @fspCode nvarchar(50),
  @deliverableCode int
AS
BEGIN

   INSERT INTO [FundingAllocation].[AllocationLineConfig]([FundingStreamCode]
                                      ,[PeriodId]
                                      ,[FundingLineCode]
                                      ,[ProviderCategory]
                                      ,[FspCode]
                                      ,[DeliverableCode])
                                VALUES
                                      (@fundingStreamCode,
                                       @periodId,
                                       @fundingLineCode,
                                       @providerCategory,
                                       @fspCode,
                                       @deliverableCode)

END
GO
COMMIT;
GO




BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_ChangeSubnominalAggregationSubnominalCode')
  BEGIN
     DROP PROCEDURE [dbo].[sp_ChangeSubnominalAggregationSubnominalCode]
  END

GO
CREATE PROCEDURE [dbo].[sp_ChangeSubnominalAggregationSubnominalCode]
    @NewSubnominalCode nvarchar(8),
 @AllocationNumber nvarchar(20),
 @Period nvarchar(6),
 @SubnominalCode nvarchar(8),
 @PaymentType nvarchar(20)

AS
BEGIN

   UPDATE PaymentGeneration.SubnominalAggregation SET    SubnominalCode = @NewSubnominalCode
		                                               WHERE  AllocationNumber = @AllocationNumber
													   AND    Period = @Period 
													   AND    SubnominalCode = @SubnominalCode 
													   AND    PaymentType = @PaymentType 

END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_ClearProcessedMessageTable')
  BEGIN
     DROP PROCEDURE [dbo].[sp_ClearProcessedMessageTable]
  END

GO
CREATE PROCEDURE [dbo].[sp_ClearProcessedMessageTable]
    @schemaName varchar(50)

AS
BEGIN

  set nocount on;
    declare @trancount int;
    set @trancount = @@trancount;
    begin try
        if @trancount = 0
            begin transaction
        else
            save transaction sp_ClearProcessedMessageTable;

		DECLARE @Sql NVARCHAR(100)
		SET @Sql='delete from'+ QUOTENAME(@schemaName)+'.ProcessedMessage'
		Print @sql;  
		EXECUTE sp_executesql @Sql

lbexit:
        if @trancount = 0
            commit;
    end try
    begin catch
        declare @error int, @message varchar(4000), @xstate int;
        select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();
        if @xstate = -1
            rollback;
        if @xstate = 1 and @trancount = 0
            rollback
        if @xstate = 1 and @trancount > 0
            rollback transaction usp_my_procedure_name;

        raiserror ('sp_ClearProcessedMessageTable: %d: %s', 16, 1, @error, @message) ;
    end catch

END
GO
COMMIT;
GO



BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_CreateProcessedMessageRows')
  BEGIN
     DROP PROCEDURE [dbo].[sp_CreateProcessedMessageRows]
  END

GO
CREATE PROCEDURE [dbo].[sp_CreateProcessedMessageRows]
   @schemaName varchar(50),
	@createDateOfProcessedMessage datetime

AS
BEGIN

   set nocount on;
    declare @trancount int;
    set @trancount = @@trancount;
    begin try
        if @trancount = 0
            begin transaction
        else
            save transaction sp_CreateProcessedMessageRows;

		DECLARE @Sql NVARCHAR(100)
		Declare @id UNIQUEIDENTIFIER =NEWID()
		SET @Sql='INSERT'+ @schemaName+'.ProcessedMessage(MessageId, CreatedDate)Values+('+ CAST(@id AS nvarchar(max)) +','+ @createDateOfProcessedMessage+')';
		
		EXECUTE sp_executesql @Sql

lbexit:
        if @trancount = 0
            commit;
    end try
    begin catch
        declare @error int, @message varchar(4000), @xstate int;
        select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();
        if @xstate = -1
            rollback;
        if @xstate = 1 and @trancount = 0
            rollback
        if @xstate = 1 and @trancount > 0
            rollback transaction usp_my_procedure_name;

        raiserror ('sp_CreateProcessedMessageRows: %d: %s', 16, 1, @error, @message) ;
    end catch

END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_DeleteByBusinessKey')
  BEGIN
     DROP PROCEDURE [dbo].[sp_DeleteByBusinessKey]
  END

GO
CREATE PROCEDURE [dbo].[sp_DeleteByBusinessKey]
     @fundingTypeCode nvarchar(50),
	@fundingPeriod nvarchar(50),
	@fspGroupCode nvarchar(50),
	@contractType nvarchar(100)

AS
BEGIN

   DELETE FROM FundingAllocation.ReleaseGroup
                            WHERE
                                FundingTypeCode = @fundingTypeCode AND
                                FundingPeriodCode = @fundingPeriod AND
                                FSPGroupCode = @fspGroupCode AND
                                ContractType = @contractType;

END
GO
COMMIT;
GO



BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_DynamicClearData')
  BEGIN
     DROP PROCEDURE [dbo].[sp_DynamicClearData]
  END

GO
CREATE PROCEDURE [dbo].[sp_DynamicClearData]
     @table NVARCHAR(MAX),
   @schema NVARCHAR(30),
   @Reqtype NVARCHAR(10)

AS
BEGIN

  set nocount on;
    declare @trancount int;
    set @trancount = @@trancount;
    begin try
        if @trancount = 0
            begin transaction
        else
            save transaction sp_DynamicClearData;

       DECLARE @Sql NVARCHAR(100)
			 IF @Reqtype='DELETE'  		
			 BEGIN
				SET @Sql='DELETE FROM '+ QUOTENAME(@schema)+'.'+QUOTENAME(@table)
			 END 
			 IF @Reqtype='TRUNCATE'
			 BEGIN
			     SET @Sql='TRUNCATE TABLE '+ QUOTENAME(@schema)+'.'+QUOTENAME(@table)  
			 END
				
				EXECUTE sp_executesql @Sql

lbexit:
        if @trancount = 0
            commit;
    end try
    begin catch
        declare @error int, @message varchar(4000), @xstate int;
        select @error = ERROR_NUMBER(), @message = ERROR_MESSAGE(), @xstate = XACT_STATE();
        if @xstate = -1
            rollback;
        if @xstate = 1 and @trancount = 0
            rollback
        if @xstate = 1 and @trancount > 0
            rollback transaction usp_my_procedure_name;

        raiserror ('sp_DynamicClearData: %d: %s', 16, 1, @error, @message) ;
    end catch

END
GO
COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_FundingAllocationGetByFundingId')
  BEGIN
     DROP PROCEDURE [dbo].[sp_FundingAllocationGetByFundingId]
  END

GO
CREATE PROCEDURE [dbo].[sp_FundingAllocationGetByFundingId]
    @fundingId nvarchar(200)

AS
BEGIN

     SELECT
	                    fa.FundingId,
	                    fa.FundingVersion,
	                    fa.Period,
	                    fa.AllocationFundingStream,
	                    fa.Ukprn,
	                    fa.Value,
                        fa.Status,
                        fa.SubStatus,
	                    rg.ReleaseGroupName
                    FROM
	                    FundingAllocation.FundingAllocation fa
	                    LEFT JOIN FundingAllocation.ReleaseGroup rg ON rg.Id = fa.ReleaseGroupId
                    WHERE
                        fa.FundingId = @fundingId

END
GO
COMMIT;
GO


BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_GetByFundingAllocationFundingId')
  BEGIN
     DROP PROCEDURE [dbo].[sp_GetByFundingAllocationFundingId]
  END

GO
CREATE PROCEDURE [dbo].[sp_GetByFundingAllocationFundingId]
     @fundingId nvarchar(200)

AS
BEGIN

    SELECT
	fa.FundingId,
	c.ContractNumber,
	c.ContractVersionNumber,
	c.ContractSubVersionNumber,
	c.IsCreatedInCrm
FROM
	FundingAllocation.FundingAllocation fa
	INNER JOIN FundingAllocation.Contract c ON c.Id = fa.ContractId
WHERE
    fa.FundingId = @fundingId

END
GO
COMMIT;
GO

BEGIN TRANSACTION;
GO
IF EXISTS (SELECT *
           FROM   INFORMATION_SCHEMA.ROUTINES
           WHERE  ROUTINE_SCHEMA = 'dbo'
                  AND ROUTINE_NAME = 'sp_GetReleaseGroupStatus')
  BEGIN
     DROP PROCEDURE [dbo].[sp_GetReleaseGroupStatus]
  END

GO
CREATE PROCEDURE [dbo].[sp_GetReleaseGroupStatus]
      @releaseGroupName nvarchar(50)

AS
BEGIN

   SELECT Status from FundingAllocation.ReleaseGroup
        WHERE ReleaseGroupName = @releaseGroupName

END
GO
COMMIT;
GO

