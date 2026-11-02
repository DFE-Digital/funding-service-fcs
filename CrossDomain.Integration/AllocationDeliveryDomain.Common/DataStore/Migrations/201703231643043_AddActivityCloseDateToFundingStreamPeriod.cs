namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddActivityCloseDateToFundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.FundingStreamPeriod", "ActivityCloseDate", c => c.DateTime());
        }
        
        public override void Down()
        {
            DropColumn("MonitoringDeliverables.FundingStreamPeriod", "ActivityCloseDate");
        }
    }
}
