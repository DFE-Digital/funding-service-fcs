namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddUkprnToApprovedContractTableAndDeliveryOrganisationUkprnToApprovedContractAllocationTable : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.ApprovedContractAllocation", "DeliveryOrganisationUkprn", c => c.Int(nullable: false));
            AddColumn("ContractManagement.ApprovedContract", "Ukprn", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.ApprovedContract", "Ukprn");
            DropColumn("ContractManagement.ApprovedContractAllocation", "DeliveryOrganisationUkprn");
        }
    }
}
