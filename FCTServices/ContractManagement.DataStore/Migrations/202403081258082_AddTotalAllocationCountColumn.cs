namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddTotalAllocationCountColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.CreatedContract", "TotalAllocationCount", c => c.Int(nullable: true));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.CreatedContract", "TotalAllocationCount");
        }
    }
}
