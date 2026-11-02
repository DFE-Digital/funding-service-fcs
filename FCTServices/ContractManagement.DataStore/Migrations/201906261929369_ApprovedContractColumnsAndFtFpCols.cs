namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ApprovedContractColumnsAndFtFpCols : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.ApprovedContractAllocation", "PlannedValue", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("ContractManagement.ApprovedContract", "MasterContractNumber", c => c.String(maxLength: 50));
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "IncludeAllContractsOnSummaryOfFunding", c => c.Boolean(nullable: false));
            CreateIndex("ContractManagement.ApprovedContract", "MasterContractNumber", name: "IX_ApprovedContractMasterContract");
        }
        
        public override void Down()
        {
            DropIndex("ContractManagement.ApprovedContract", "IX_ApprovedContractMasterContract");
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "IncludeAllContractsOnSummaryOfFunding");
            DropColumn("ContractManagement.ApprovedContract", "MasterContractNumber");
            DropColumn("ContractManagement.ApprovedContractAllocation", "PlannedValue");
        }
    }
}
