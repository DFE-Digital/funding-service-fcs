namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ApprovedContractAllocationTableMakeHasOutstandingPaymentsNullable : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.ApprovedContractAllocation", "HasOutstandingPayments", c => c.Boolean());
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.ApprovedContractAllocation", "HasOutstandingPayments", c => c.Boolean(nullable: false));
        }
    }
}
