namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class PlannedValueColumns : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.ApprovedContractAllocation", "TotalPlannedValue", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("ContractManagement.ApprovedContractAllocation", "PlannedValueEnvelope1", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("ContractManagement.ApprovedContractAllocation", "PlannedValueEnvelope2", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            AddColumn("ContractManagement.ApprovedContractAllocation", "FundingStreamPeriodCode", c => c.String());
            DropColumn("ContractManagement.ApprovedContractAllocation", "PlannedValue");
        }
        
        public override void Down()
        {
            AddColumn("ContractManagement.ApprovedContractAllocation", "PlannedValue", c => c.Decimal(nullable: false, precision: 18, scale: 2));
            DropColumn("ContractManagement.ApprovedContractAllocation", "FundingStreamPeriodCode");
            DropColumn("ContractManagement.ApprovedContractAllocation", "PlannedValueEnvelope2");
            DropColumn("ContractManagement.ApprovedContractAllocation", "PlannedValueEnvelope1");
            DropColumn("ContractManagement.ApprovedContractAllocation", "TotalPlannedValue");
        }
    }
}
