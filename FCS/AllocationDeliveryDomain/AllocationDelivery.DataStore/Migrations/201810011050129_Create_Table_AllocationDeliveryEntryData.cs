namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Create_Table_AllocationDeliveryEntryData : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "AllocationDelivery.AllocationDeliveryEntryData",
                c => new
                    {
                        EntryID = c.Int(nullable: false),
                        CorporateAllocationDeliveryBytes = c.Binary(nullable: false),
                    })
                .PrimaryKey(t => t.EntryID)
                .ForeignKey("AllocationDelivery.AllocationDeliveryEntry", t => t.EntryID)
                .Index(t => t.EntryID);
            
        }
        
        public override void Down()
        {
            DropForeignKey("AllocationDelivery.AllocationDeliveryEntryData", "EntryID", "AllocationDelivery.AllocationDeliveryEntry");
            DropIndex("AllocationDelivery.AllocationDeliveryEntryData", new[] { "EntryID" });
            DropTable("AllocationDelivery.AllocationDeliveryEntryData");
        }
    }
}
