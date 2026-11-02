namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCreatedDateToFundingClaimsAllocationsAndDeliverables : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.FundingClaim", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
            AddColumn("PerformanceManagement.FundingClaimContractAllocation", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
            AddColumn("PerformanceManagement.FundingClaimDeliverable", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
            AddColumn("PerformanceManagement.FundingClaimCollectionImportInfo", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.FundingClaim", "CreatedDate");
            DropColumn("PerformanceManagement.FundingClaimContractAllocation", "CreatedDate");
            DropColumn("PerformanceManagement.FundingClaimDeliverable", "CreatedDate");
            DropColumn("PerformanceManagement.FundingClaimCollectionImportInfo", "CreatedDate");
        }
    }
}
