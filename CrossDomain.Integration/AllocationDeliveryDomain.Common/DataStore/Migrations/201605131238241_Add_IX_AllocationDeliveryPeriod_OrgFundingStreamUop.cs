namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class Add_IX_AllocationDeliveryPeriod_OrgFundingStreamUop : DbMigration
    {
        public override void Up()
        {
            CreateIndex("MonitoringDeliverables.AllocationDeliverablePeriod", new[] { "OrganisationId", "FundingStreamPeriodCode", "UopCode" }, name: "IX_AllocationDeliveryPeriod_OrgFundingStreamUop");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.AllocationDeliverablePeriod", "IX_AllocationDeliveryPeriod_OrgFundingStreamUop");
        }
    }
}
