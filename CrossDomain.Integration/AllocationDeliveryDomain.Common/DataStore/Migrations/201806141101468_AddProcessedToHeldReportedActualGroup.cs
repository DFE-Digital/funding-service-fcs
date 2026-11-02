namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddProcessedToHeldReportedActualGroup : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.HeldReportedActualGroup", "Processed", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("MonitoringDeliverables.HeldReportedActualGroup", "Processed");
        }
    }
}
