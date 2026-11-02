using System.Data.Entity.Migrations;

namespace ADMonitoringDomain.DataStore.Migrations
{
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "AllocationDeliveryMonitoring.AllocationDeliveryEventReceived",
                c => new
                    {
                        AllocationNumber = c.String(nullable: false, maxLength: 128),
                        VersionNumber = c.Int(nullable: false),
                        CategoryName = c.String(nullable: false, maxLength: 128),
                        EventName = c.String(nullable: false, maxLength: 128),
                        EventReceived = c.DateTime(nullable: false),
                        ObjectType = c.String(),
                        SerializedXml = c.String(),
                    })
                .PrimaryKey(t => new { t.AllocationNumber, t.VersionNumber, t.CategoryName, t.EventName });
            
        }
        
        public override void Down()
        {
            DropTable("AllocationDeliveryMonitoring.AllocationDeliveryEventReceived");
        }
    }
}
