namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FundingClaimCollectionImportInfo_Column_Rename : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.FundingClaimCollectionImportInfo", "ImportCompletedDate", c => c.DateTime());
            DropColumn("PerformanceManagement.FundingClaimCollectionImportInfo", "LastSuccessfulRunDate");
        }
        
        public override void Down()
        {
            AddColumn("PerformanceManagement.FundingClaimCollectionImportInfo", "LastSuccessfulRunDate", c => c.DateTime());
            DropColumn("PerformanceManagement.FundingClaimCollectionImportInfo", "ImportCompletedDate");
        }
    }
}
