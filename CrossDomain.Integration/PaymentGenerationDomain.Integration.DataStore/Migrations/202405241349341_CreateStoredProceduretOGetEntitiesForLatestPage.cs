namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateStoredProceduretOGetEntitiesForLatestPage : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_PayGenDomain_GetEntitiesForLatestPage", c => new
            {
                rowsInLatestPage = c.Int(10)

            }, StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_PayGenDomain_GetEntitiesForLatestPage");
        }

        private const string StoredProcedureBody = @"SELECT TOP (@rowsInLatestPage) 
                     [Id] AS [Id]
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
                ORDER BY [ID] DESC";
    }
}
