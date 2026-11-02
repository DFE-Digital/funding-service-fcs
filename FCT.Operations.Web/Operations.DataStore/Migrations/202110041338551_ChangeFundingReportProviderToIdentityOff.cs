namespace Operations.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ChangeFundingReportProviderToIdentityOff : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("Operations.FundingReportProvider");
            AlterColumn("Operations.FundingReportProvider", "Ukprn", c => c.Int(nullable: false));
            AddPrimaryKey("Operations.FundingReportProvider", new[] { "Ukprn", "FundingPeriod" });
        }
        
        public override void Down()
        {
            DropPrimaryKey("Operations.FundingReportProvider");
            AlterColumn("Operations.FundingReportProvider", "Ukprn", c => c.Int(nullable: false, identity: true));
            AddPrimaryKey("Operations.FundingReportProvider", "Ukprn");
        }
    }
}
