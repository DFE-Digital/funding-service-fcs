namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCdaReportConfigTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.CdaReportFundingStreamPeriod",
                c => new
                    {
                        ExtractName = c.String(nullable: false, maxLength: 100),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                    })
                .PrimaryKey(t => new { t.ExtractName, t.FundingStreamPeriodCode });
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.CdaReportFundingStreamPeriod");
        }
    }
}
