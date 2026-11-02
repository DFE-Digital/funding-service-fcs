namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ChangeProcessedToNullableProcessedDateHeldReportedActualGroup : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.HeldReportedActualGroup", "ProcessedDate", c => c.DateTime());
            DropColumn("MonitoringDeliverables.HeldReportedActualGroup", "Processed");
            AddColumn("MonitoringDeliverables.HeldReportedActualGroup", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }

        public override void Down()
        {
            AddColumn("MonitoringDeliverables.HeldReportedActualGroup", "Processed", c => c.DateTime(nullable: false));
            DropColumn("MonitoringDeliverables.HeldReportedActualGroup", "ProcessedDate");
        }
    }
}
