namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ApprovedContractAllocationIndexForFsp : DbMigration
    {
        public override void Up()
        {
            CreateIndex("ContractManagement.ApprovedContractAllocation", "FundingStreamPeriodCode", name: "IX_ApprovedContractAllocationFsp");
        }
        
        public override void Down()
        {
            DropIndex("ContractManagement.ApprovedContractAllocation", "IX_ApprovedContractAllocationFsp");
        }
    }
}
