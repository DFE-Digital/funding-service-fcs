namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddNullableAllocationNumberAndVersionNumber : DbMigration
    {
        public override void Up()
        {
            AddColumn("AllocationDelivery.AllocationDeliveryEntry", "AllocationNumber", c => c.String(maxLength: 20, nullable: true));
            AddColumn("AllocationDelivery.AllocationDeliveryEntry", "VersionNumber", c => c.Int(nullable: true));
            AddColumn("AllocationDelivery.AllocationDeliveryEntry", "SubVersionNumber", c => c.Int(nullable: true));
            CreateIndex("AllocationDelivery.AllocationDeliveryEntry", "AllocationNumber", name: "IX_AllocationDeliveryEntry_AllocationNumber");
        }
        
        public override void Down()
        {
            DropIndex("AllocationDelivery.AllocationDeliveryEntry", "IX_AllocationDeliveryEntry_AllocationNumber");
            DropColumn("AllocationDelivery.AllocationDeliveryEntry", "SubVersionNumber");
            DropColumn("AllocationDelivery.AllocationDeliveryEntry", "VersionNumber");
            DropColumn("AllocationDelivery.AllocationDeliveryEntry", "AllocationNumber");
        }
    }
}
