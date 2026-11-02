namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ActualsAudit2 : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit");
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CollectionReturnPeriod", c => c.Int(nullable: false));
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CollectionReturnCode", c => c.String(maxLength: 10));
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CollectionType", c => c.String(maxLength: 20));
            AddPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", new[] { "CollectionReturnPeriod", "OrganisationId", "FundingStreamPeriodCode", "UopCode", "DeliverableCode", "Period" });
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "RecordedPeriod");
        }
        
        public override void Down()
        {
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "RecordedPeriod", c => c.Int(nullable: false));
            DropPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit");
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CollectionType", c => c.String());
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CollectionReturnCode", c => c.String());
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CollectionReturnPeriod");
            AddPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", new[] { "RecordedPeriod", "OrganisationId", "FundingStreamPeriodCode", "UopCode", "DeliverableCode", "Period" });
        }
    }
}
