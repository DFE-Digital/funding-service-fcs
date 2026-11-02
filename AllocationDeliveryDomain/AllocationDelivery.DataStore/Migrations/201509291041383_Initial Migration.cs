namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialMigration : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "AllocationDelivery.AllocationDeliveryEntry",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        Identifier = c.Guid(nullable: false),
                        AllocationDeliveryCategory = c.Int(nullable: false),
                        CorporateAllocationDeliveryXml = c.String(),
                        CreatedDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.ID);
            
        }
        
        public override void Down()
        {
            DropTable("AllocationDelivery.AllocationDeliveryEntry");
        }
    }
}
