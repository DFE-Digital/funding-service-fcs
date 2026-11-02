namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddSchemaVersionToAllocationDeliveryEntry : DbMigration
    {
        public override void Up()
        {
            AddColumn("AllocationDelivery.AllocationDeliveryEntry", "SchemaVersion", c => c.String(nullable: false, maxLength: 10));
        }
        
        public override void Down()
        {
            DropColumn("AllocationDelivery.AllocationDeliveryEntry", "SchemaVersion");
        }
    }
}
