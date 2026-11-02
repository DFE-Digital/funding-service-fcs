namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class New_Column_CorporateAllocationDeliveryBytes : DbMigration
    {
        public override void Up()
        {
            AddColumn("AllocationDelivery.AllocationDeliveryEntry", "CorporateAllocationDeliveryBytes", c => c.Binary());
        }
        
        public override void Down()
        {
            DropColumn("AllocationDelivery.AllocationDeliveryEntry", "CorporateAllocationDeliveryBytes");
        }
    }
}
