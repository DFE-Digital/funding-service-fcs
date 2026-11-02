namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ClosedCollectionTableMakeRetrievedRowCountNullable : DbMigration
    {
        public override void Up()
        {
            AlterColumn("MonitoringDeliverables.ClosedCollection", "RetrievedRowCount", c => c.Int());
        }
        
        public override void Down()
        {
            AlterColumn("MonitoringDeliverables.ClosedCollection", "RetrievedRowCount", c => c.Int(nullable: false));
        }
    }
}
