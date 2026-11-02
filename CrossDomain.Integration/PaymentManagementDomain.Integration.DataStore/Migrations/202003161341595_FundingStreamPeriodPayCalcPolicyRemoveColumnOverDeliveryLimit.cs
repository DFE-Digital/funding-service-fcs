namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FundingStreamPeriodPayCalcPolicyRemoveColumnOverDeliveryLimit : DbMigration
    {
        public override void Up()
        {
            DropColumn("PolicyCache.FundingStreamPeriodPayCalcPolicy", "OverDeliveryLimit");
        }
        
        public override void Down()
        {
            AddColumn("PolicyCache.FundingStreamPeriodPayCalcPolicy", "OverDeliveryLimit", c => c.Int());
        }
    }
}
