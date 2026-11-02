namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddZeroiseMissingActualsField : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.FundingStreamPeriod", "ZeroiseMissingActuals", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("MonitoringDeliverables.FundingStreamPeriod", "ZeroiseMissingActuals");
        }
    }
}
