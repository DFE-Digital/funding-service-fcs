namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class TablePolicyFundingStreamPeriodNewColumnName : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicyFundingStreamPeriod", "Name", c => c.String(maxLength: 100));
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicyFundingStreamPeriod", "Name");
        }
    }
}
