namespace Operations.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddPeriodColumnToFundingReportProvider : DbMigration
    {
        public override void Up()
        {
            AddColumn("Operations.FundingReportProvider", "Period", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("Operations.FundingReportProvider", "Period");
        }
    }
}
