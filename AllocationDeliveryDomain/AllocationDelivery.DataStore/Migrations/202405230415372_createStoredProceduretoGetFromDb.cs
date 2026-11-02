namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createStoredProceduretoGetFromDb : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_AllocDelDomain_GetFromDb", c => new
            {
                fundingStreamPeriodCode = c.String(40)

            }, StoredProcedureBody);
        }
        
        public override void Down()
        {
            DropStoredProcedure("dbo.sp_AllocDelDomain_GetFromDb");
        }

        private const string StoredProcedureBody = @"SELECT [Code]
                                            ,[Name]
                                            ,[ProcessFutureActuals]
                                            ,[PersistCurrentActualsState]
                                            ,[ZeroiseMissingActuals]
                                            ,[PaymentMethod]
                                            ,[ActivityCloseDate]
                                            ,[MultiCollectionReturns]
                                    FROM [MonitoringDeliverables].[FundingStreamPeriod]
                                    WHERE [Code] = @fundingStreamPeriodCode";
    }
}
