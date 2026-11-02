namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ChangeFundingAllocationReleaseTable : DbMigration
    {
        public override void Up()
        {
            DropIndex("ContractRequest.FundingAllocationRelease", "IX_FundingTypeCodeFundingPeriodNameReleaseStatus");
            DropPrimaryKey("ContractRequest.FundingAllocationRelease");
            AddColumn("ContractRequest.FundingAllocationRelease", "ReleaseGroupGroupId", c => c.Int(nullable: false));
            AddPrimaryKey("ContractRequest.FundingAllocationRelease", new[] { "ReleaseGroupGroupId", "FundingTypeCode", "FundingPeriodName", "ReleaseStatus" });
            DropColumn("ContractRequest.FundingAllocationRelease", "FundingAllocationReleaseId");
        }
        
        public override void Down()
        {
            AddColumn("ContractRequest.FundingAllocationRelease", "FundingAllocationReleaseId", c => c.Int(nullable: false, identity: true));
            DropPrimaryKey("ContractRequest.FundingAllocationRelease");
            DropColumn("ContractRequest.FundingAllocationRelease", "ReleaseGroupGroupId");
            AddPrimaryKey("ContractRequest.FundingAllocationRelease", "FundingAllocationReleaseId");
            CreateIndex("ContractRequest.FundingAllocationRelease", new[] { "FundingTypeCode", "FundingPeriodName", "ReleaseStatus" }, unique: true, name: "IX_FundingTypeCodeFundingPeriodNameReleaseStatus");
        }
    }
}
