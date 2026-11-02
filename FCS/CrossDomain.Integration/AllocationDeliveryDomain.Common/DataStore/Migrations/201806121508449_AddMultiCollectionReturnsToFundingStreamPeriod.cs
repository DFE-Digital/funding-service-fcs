namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddMultiCollectionReturnsToFundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.FundingStreamPeriod", "MultiCollectionReturns", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("MonitoringDeliverables.FundingStreamPeriod", "MultiCollectionReturns");
        }
    }
}
