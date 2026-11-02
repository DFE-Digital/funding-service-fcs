namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnsToFundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("DocumentsDomain.FundingStreamPeriod", "ShouldGenerateFundingAgreement", c => c.Boolean(nullable: false));
            AddColumn("DocumentsDomain.FundingStreamPeriod", "ShouldUseContractAllocationDescription", c => c.Boolean(nullable: false));
            AddColumn("DocumentsDomain.FundingStreamPeriod", "Template", c => c.String(maxLength: 50));
            AddColumn("DocumentsDomain.FundingStreamPeriod", "ExtraPagesTemplate", c => c.String(maxLength: 50));
        }
        
        public override void Down()
        {
            DropColumn("DocumentsDomain.FundingStreamPeriod", "ExtraPagesTemplate");
            DropColumn("DocumentsDomain.FundingStreamPeriod", "Template");
            DropColumn("DocumentsDomain.FundingStreamPeriod", "ShouldUseContractAllocationDescription");
            DropColumn("DocumentsDomain.FundingStreamPeriod", "ShouldGenerateFundingAgreement");
        }
    }
}
