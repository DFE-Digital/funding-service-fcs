namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createStoredProceduretoGetSummarisedActuals : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_Operation_GetSummarisedActuals", c => new
            {
                CollectionType = c.String(20),
                CollectionReturnCode = c.String(20),
                OrganisationId = c.String(20),
                FundingStreamPeriodCode = c.String(20),
                UopCode = c.String(20),

            }, StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_Operation_GetSummarisedActuals");
        }

        private const string StoredProcedureBody = @"select [Id]
                              ,[CollectionType]
                              ,[CollectionReturnCode]
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
                               [CollectionReturnCode] = @CollectionReturnCode and
                               [OrganisationId] = @OrganisationId and
                               [FundingStreamPeriodCode] = @FundingStreamPeriodCode and
                               ISNULL([UopCode], -1) = ISNULL(@UopCode, -1)";
    }
}

