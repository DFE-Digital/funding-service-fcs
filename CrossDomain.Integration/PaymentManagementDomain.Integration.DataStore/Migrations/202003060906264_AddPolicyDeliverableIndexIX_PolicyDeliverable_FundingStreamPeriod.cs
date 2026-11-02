namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddPolicyDeliverableIndexIX_PolicyDeliverable_FundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            CreateIndex("PolicyCache.PolicyDeliverable", "FundingStreamPeriod", name: "IX_PolicyDeliverable_FundingStreamPeriod");
        }
        
        public override void Down()
        {
            DropIndex("PolicyCache.PolicyDeliverable", "IX_PolicyDeliverable_FundingStreamPeriod");
        }
    }
}
