namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ActualsAudit3 : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "ContractVersion", c => c.Int(nullable: false));
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "ContractSubVersion", c => c.Int(nullable: false));
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "ContractVersionNumber");
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "ContractSubVersionNumber");
        }
        
        public override void Down()
        {
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "ContractSubVersionNumber", c => c.Int(nullable: false));
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "ContractVersionNumber", c => c.Int(nullable: false));
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "ContractSubVersion");
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "ContractVersion");
        }
    }
}
