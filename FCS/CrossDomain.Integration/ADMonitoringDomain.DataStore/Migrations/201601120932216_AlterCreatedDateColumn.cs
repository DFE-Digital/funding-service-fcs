namespace ADMonitoringDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AlterCreatedDateColumn : DbMigration
    {
        public override void Up()
        {
            AlterColumn("AllocationDeliveryMonitoring.AllocationDeliveryEventReceived", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
        }
        
        public override void Down()
        {
            AlterColumn("AllocationDeliveryMonitoring.AllocationDeliveryEventReceived", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
    }
}
