namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AlterCreatedDateColumn : DbMigration
    {
        public override void Up()
        {
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("MonitoringDeliverables.CurrentViewActual", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("MonitoringDeliverables.FundingStreamPeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("MonitoringDeliverables.FundingStreamPeriodDeliverable", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
        }
        
        public override void Down()
        {
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AlterColumn("MonitoringDeliverables.CurrentViewActual", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AlterColumn("MonitoringDeliverables.FundingStreamPeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AlterColumn("MonitoringDeliverables.FundingStreamPeriodDeliverable", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
    }
}
