namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ReindexAllocDPActualAudit : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit");
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "Id", c => c.Int(nullable: false, identity: true));
            AddPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "Id");
            CreateIndex("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", new[] { "ContractAllocationNumber", "Period", "CollectionReturnPeriod", "DeliverableCode", "FundingStreamPeriodCode", "OrganisationId", "UopCode" }, unique: true, name: "IX_AllocationDeliveryPeriodActualAudit_Unique");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "IX_AllocationDeliveryPeriodActualAudit_Unique");
            DropPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit");
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "Id");
            AddPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", new[] { "CollectionReturnPeriod", "OrganisationId", "FundingStreamPeriodCode", "UopCode", "DeliverableCode", "Period" });
        }
    }
}
