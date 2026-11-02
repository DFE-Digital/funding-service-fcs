namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ReIndexCurrentViewActuals : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("MonitoringDeliverables.CurrentViewActual");
            AddColumn("MonitoringDeliverables.CurrentViewActual", "Id", c => c.Int(nullable: false, identity: true));
            AddPrimaryKey("MonitoringDeliverables.CurrentViewActual", "Id");
            CreateIndex("MonitoringDeliverables.CurrentViewActual", new[] { "OrganisationId", "Period", "FundingStreamPeriodCode", "ContractAllocationNumber", "UoPCode", "DeliverableCode" }, unique: true, name: "IX_OrgIdPeriodFSPCUoPDeliverableCode");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.CurrentViewActual", "IX_OrgIdPeriodFSPCUoPDeliverableCode");
            DropPrimaryKey("MonitoringDeliverables.CurrentViewActual");
            DropColumn("MonitoringDeliverables.CurrentViewActual", "Id");
            AddPrimaryKey("MonitoringDeliverables.CurrentViewActual", new[] { "OrganisationId", "Period", "FundingStreamPeriodCode", "UoPCode", "DeliverableCode" });
        }
    }
}
