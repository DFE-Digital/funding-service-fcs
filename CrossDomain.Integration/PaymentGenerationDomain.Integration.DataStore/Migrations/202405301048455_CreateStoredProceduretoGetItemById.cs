namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateStoredProceduretoGetItemById : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_PayGenDomain_GetItemById", c => new
            {
                id = c.Int(10)

            }, StoredProcedureBody);
        }
        
        public override void Down()
        {
            DropStoredProcedure("dbo.sp_PayGenDomain_GetItemById");
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
                WHERE [Id] = @id";

    }
}
