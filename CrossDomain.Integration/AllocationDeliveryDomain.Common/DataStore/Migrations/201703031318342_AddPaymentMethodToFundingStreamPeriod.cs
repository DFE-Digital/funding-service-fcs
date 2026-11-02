namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddPaymentMethodToFundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.FundingStreamPeriod", "PaymentMethod", c => c.Int(nullable: false));
            DropColumn("MonitoringDeliverables.FundingStreamPeriod", "PaymentType");
        }
        
        public override void Down()
        {
            AddColumn("MonitoringDeliverables.FundingStreamPeriod", "PaymentType", c => c.Int(nullable: false));
            DropColumn("MonitoringDeliverables.FundingStreamPeriod", "PaymentMethod");
        }
    }
}
