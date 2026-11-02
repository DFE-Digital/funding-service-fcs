namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCreatedDateColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("MonitoringDeliverables.CurrentViewActual", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("MonitoringDeliverables.FundingStreamPeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("MonitoringDeliverables.FundingStreamPeriodDeliverable", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
        
        public override void Down()
        {
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "CreatedDate");
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CreatedDate");
            DropColumn("MonitoringDeliverables.CurrentViewActual", "CreatedDate");
            DropColumn("MonitoringDeliverables.FundingStreamPeriod", "CreatedDate");
            DropColumn("MonitoringDeliverables.FundingStreamPeriodDeliverable", "CreatedDate");
        }
    }
}
