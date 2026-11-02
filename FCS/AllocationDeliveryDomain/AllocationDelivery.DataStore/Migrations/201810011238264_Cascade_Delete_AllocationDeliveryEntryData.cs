namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Cascade_Delete_AllocationDeliveryEntryData : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("AllocationDelivery.AllocationDeliveryEntryData", "EntryID", "AllocationDelivery.AllocationDeliveryEntry");
            AddForeignKey("AllocationDelivery.AllocationDeliveryEntryData", "EntryID", "AllocationDelivery.AllocationDeliveryEntry", "ID", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("AllocationDelivery.AllocationDeliveryEntryData", "EntryID", "AllocationDelivery.AllocationDeliveryEntry");
            AddForeignKey("AllocationDelivery.AllocationDeliveryEntryData", "EntryID", "AllocationDelivery.AllocationDeliveryEntry", "ID");
        }
    }
}
