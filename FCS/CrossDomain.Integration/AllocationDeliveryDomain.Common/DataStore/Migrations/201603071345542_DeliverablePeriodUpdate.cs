namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DeliverablePeriodUpdate : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriod");
            AddColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "Id", c => c.Int(nullable: false, identity: true));
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "ContractAllocationNumber", c => c.String(nullable: false, maxLength: 20));
            AddPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriod", "Id");
            CreateIndex("MonitoringDeliverables.AllocationDeliverablePeriod", new[] { "ContractAllocationNumber", "DeliverableCode", "Period" }, unique: true, name: "IX_AllocationDeliveryPeriod_AllocationRefPeriodDeliverableCode");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.AllocationDeliverablePeriod", "IX_AllocationDeliveryPeriod_AllocationRefPeriodDeliverableCode");
            DropPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriod");
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "ContractAllocationNumber", c => c.String(maxLength: 20));
            DropColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "Id");
            AddPrimaryKey("MonitoringDeliverables.AllocationDeliverablePeriod", new[] { "OrganisationId", "FundingStreamPeriodCode", "UopCode", "DeliverableCode", "Period" });
        }
    }
}
