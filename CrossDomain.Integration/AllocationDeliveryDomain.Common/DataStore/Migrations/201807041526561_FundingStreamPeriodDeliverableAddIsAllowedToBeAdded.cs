namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FundingStreamPeriodDeliverableAddIsAllowedToBeAdded : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.FundingStreamPeriodDeliverable", "IsAllowedToBeAdded", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("MonitoringDeliverables.FundingStreamPeriodDeliverable", "IsAllowedToBeAdded");
        }
    }
}
