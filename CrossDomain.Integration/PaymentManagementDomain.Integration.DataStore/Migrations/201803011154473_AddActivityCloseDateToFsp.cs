namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddActivityCloseDateToFsp : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicyFundingStreamPeriod", "ActivityCloseDate", c => c.DateTime(precision:0, storeType: "datetime2"));
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicyFundingStreamPeriod", "ActivityCloseDate");
        }
    }
}
