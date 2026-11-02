namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddPayCalcPolicyVersionToPolicyFundingStreamCensusDate : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicyFundingStreamCensusDate", "PayCalcPolicyVersion", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicyFundingStreamCensusDate", "PayCalcPolicyVersion");
        }
    }
}
