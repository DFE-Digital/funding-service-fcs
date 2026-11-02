namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemoveColumnCorporateAllocationDeliveryXML : DbMigration
    {
        public override void Up()
        {
            DropColumn("AllocationDelivery.AllocationDeliveryEntry", "CorporateAllocationDeliveryXml");
        }
        
        public override void Down()
        {
            AddColumn("AllocationDelivery.AllocationDeliveryEntry", "CorporateAllocationDeliveryXml", c => c.String());
        }
    }
}
