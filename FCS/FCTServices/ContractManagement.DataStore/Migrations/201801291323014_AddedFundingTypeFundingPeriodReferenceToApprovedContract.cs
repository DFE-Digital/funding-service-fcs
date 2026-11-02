namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddedFundingTypeFundingPeriodReferenceToApprovedContract : DbMigration
    {
        public override void Up()
        {
            CreateIndex("ContractManagement.ApprovedContract", new[] { "FundingType", "FundingPeriod" });
            AddForeignKey("ContractManagement.ApprovedContract", new[] { "FundingType", "FundingPeriod" }, "ContractManagement.FundingTypeFundingPeriod", new[] { "FundingTypeCode", "FundingPeriodName" });
        }
        
        public override void Down()
        {
            DropForeignKey("ContractManagement.ApprovedContract", new[] { "FundingType", "FundingPeriod" }, "ContractManagement.FundingTypeFundingPeriod");
            DropIndex("ContractManagement.ApprovedContract", new[] { "FundingType", "FundingPeriod" });
        }
    }
}
