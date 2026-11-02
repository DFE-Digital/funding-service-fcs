namespace ADMonitoringDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCreatedDateColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("AllocationDeliveryMonitoring.AllocationDeliveryEventReceived", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
        
        public override void Down()
        {
            DropColumn("AllocationDeliveryMonitoring.AllocationDeliveryEventReceived", "CreatedDate");
        }
    }
}
