namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RenameColumnToSummaryOfFundingDisplayNameOnFundingStreamPeriodTable : DbMigration
    {
        public override void Up()
        {
            AddColumn("DocumentsDomain.FundingStreamPeriod", "SummaryOfFundingDisplayName", c => c.String(maxLength: 100));
            Sql("UPDATE [DocumentsDomain].[FundingStreamPeriod] SET SummaryOfFundingDisplayName = DisplayName");
            DropColumn("DocumentsDomain.FundingStreamPeriod", "DisplayName");
        }
        
        public override void Down()
        {
            AddColumn("DocumentsDomain.FundingStreamPeriod", "DisplayName", c => c.String(maxLength: 100));
            Sql("UPDATE [DocumentsDomain].[FundingStreamPeriod] SET DisplayName = SummaryOfFundingDisplayName");
            DropColumn("DocumentsDomain.FundingStreamPeriod", "SummaryOfFundingDisplayName");
        }
    }
}
