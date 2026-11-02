namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateStoredProceduretoGetEntitiesForPage : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_PayGenDomain_GetEntitiesForPage", c => new
            {
                skip = c.Int(10),
                pageSize = c.Int(10)

            }, StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_PayGenDomain_GetEntitiesForPage");
        }

        private const string StoredProcedureBody = @"SELECT [Id] AS [Id]
                    ,[Identifier] AS[Identifier]
                    ,[FundingStreamPeriod] AS[FundingStreamPeriod]
                    ,[PaymentPeriod] AS[PaymentPeriod]
                    ,[CensusEndDate] AS[CensusEndDate]
                    ,[PaymentLineCount] AS[PaymentLineCount]
                    ,[LinkCodeSuffix] AS[LinkCodeSuffix]
                    ,[CorporatePaymentBatchBytes] AS[CorporatePaymentBatchBytes]
                    ,[CreatedDate] AS[CreatedDate]
                    ,[TotalValue]  AS[TotalValue]
                FROM [PaymentGeneration].[PaymentBatchFeedItem]
                ORDER BY row_number() OVER (ORDER BY [ID] ASC)
                OFFSET @skip ROWS FETCH NEXT @pageSize ROWS ONLY";
    }
}

