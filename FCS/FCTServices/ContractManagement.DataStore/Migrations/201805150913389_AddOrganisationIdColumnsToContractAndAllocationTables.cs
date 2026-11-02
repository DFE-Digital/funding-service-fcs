namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddOrganisationIdColumnsToContractAndAllocationTables : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.ApprovedContractAllocation", "DeliveryOrganisationId", c => c.String(maxLength: 10));
            AddColumn("ContractManagement.ApprovedContract", "OrganisationId", c => c.String(maxLength: 10));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.ApprovedContract", "OrganisationId");
            DropColumn("ContractManagement.ApprovedContractAllocation", "DeliveryOrganisationId");
        }
    }
}
