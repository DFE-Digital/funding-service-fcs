namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateIndexOnAllocationDeliverablePeriodForFspOrgUop : DbMigration
    {
        public override void Up()
        {
            DropIndex("MonitoringDeliverables.AllocationDeliverablePeriod", "IX_AllocationDeliveryPeriod_OrgFundingStreamUop");
            CreateIndex("MonitoringDeliverables.AllocationDeliverablePeriod", new[] { "FundingStreamPeriodCode", "OrganisationId", "UopCode" }, name: "IX_AllocationDeliverablePeriod_FspOrgUop");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.AllocationDeliverablePeriod", "IX_AllocationDeliverablePeriod_FspOrgUop");
            CreateIndex("MonitoringDeliverables.AllocationDeliverablePeriod", new[] { "OrganisationId", "FundingStreamPeriodCode", "UopCode" }, name: "IX_AllocationDeliveryPeriod_OrgFundingStreamUop");
        }
    }
}
