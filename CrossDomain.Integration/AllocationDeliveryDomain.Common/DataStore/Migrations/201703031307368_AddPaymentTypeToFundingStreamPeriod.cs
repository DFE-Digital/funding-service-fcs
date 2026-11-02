namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddPaymentTypeToFundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.FundingStreamPeriod", "PaymentType", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("MonitoringDeliverables.FundingStreamPeriod", "PaymentType");
        }
    }
}
