namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreatedDateIssue : DbMigration
    {
        public override void Up()
        {
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "CreatedDate", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "CreatedDate", c => c.DateTime(nullable: false));
        }
    }
}
