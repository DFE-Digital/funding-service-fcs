namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class ChangePkOnFundingReportFsp : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("Operations.FundingReportFSP");
            AddPrimaryKey("Operations.FundingReportFSP", new[] { "FspCode", "FundingPeriod" });
        }
        
        public override void Down()
        {
            DropPrimaryKey("Operations.FundingReportFSP");
            AddPrimaryKey("Operations.FundingReportFSP", "FspCode");
        }
    }
}
