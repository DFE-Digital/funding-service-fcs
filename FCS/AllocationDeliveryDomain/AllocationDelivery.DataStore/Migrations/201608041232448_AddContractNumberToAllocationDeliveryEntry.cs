namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddContractNumberToAllocationDeliveryEntry : DbMigration
    {
        public override void Up()
        {
            DropIndex("AllocationDelivery.AllocationDeliveryEntry", "IX_AllocationDeliveryEntry_AllocationNumber");
            AddColumn("AllocationDelivery.AllocationDeliveryEntry", "ContractNumber", c => c.String(nullable: false, maxLength: 20));
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "AllocationNumber", c => c.String(nullable: false, maxLength: 20));
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "VersionNumber", c => c.Int(nullable: false));
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "SubVersionNumber", c => c.Int(nullable: false));
            CreateIndex("AllocationDelivery.AllocationDeliveryEntry", "AllocationNumber", name: "IX_AllocationDeliveryEntry_AllocationNumber");
        }
        
        public override void Down()
        {
            DropIndex("AllocationDelivery.AllocationDeliveryEntry", "IX_AllocationDeliveryEntry_AllocationNumber");
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "SubVersionNumber", c => c.Int());
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "VersionNumber", c => c.Int());
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "AllocationNumber", c => c.String(maxLength: 20));
            DropColumn("AllocationDelivery.AllocationDeliveryEntry", "ContractNumber");
            CreateIndex("AllocationDelivery.AllocationDeliveryEntry", "AllocationNumber", name: "IX_AllocationDeliveryEntry_AllocationNumber");
        }
    }
}
