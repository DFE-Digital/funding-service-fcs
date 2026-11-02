namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MakeApprovedContractAllocationDeliveryOrganisationUkprnNullable : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.ApprovedContractAllocation", "DeliveryOrganisationUkprn", c => c.Int());
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.ApprovedContractAllocation", "DeliveryOrganisationUkprn", c => c.Int(nullable: false));
        }
    }
}
