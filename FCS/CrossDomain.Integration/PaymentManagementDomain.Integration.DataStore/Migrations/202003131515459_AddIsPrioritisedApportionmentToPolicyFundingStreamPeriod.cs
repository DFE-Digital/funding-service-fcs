namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddIsPrioritisedApportionmentToPolicyFundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicyFundingStreamPeriod", "IsPrioritisedApportionment", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicyFundingStreamPeriod", "IsPrioritisedApportionment");
        }
    }
}
