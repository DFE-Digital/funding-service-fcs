namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFundingAgreementDisplayNameToFundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("DocumentsDomain.FundingStreamPeriod", "FundingAgreementDisplayName", c => c.String(maxLength: 200));
        }
        
        public override void Down()
        {
            DropColumn("DocumentsDomain.FundingStreamPeriod", "FundingAgreementDisplayName");
        }
    }
}
