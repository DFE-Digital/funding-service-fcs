namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createStoredProceduretoGetAvailabilityCheck : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_OpsWeb_GetAvailabilityCheckResult", c => new
            {
                serviceName = c.String(100)

            }, StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_OpsWeb_GetAvailabilityCheckResult");
        }

        private const string StoredProcedureBody = @"select  [CanConnect] isAvailable
                                         ,[ErrorInfo]
                                         ,[SupplementaryInfo]
                                from [Operations].[Connectivity]
                                where ServiceName = @serviceName";
    }
}
