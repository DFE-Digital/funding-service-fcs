namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableFundingReportProvider : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.FundingReportProvider",
                c => new
                    {
                        Ukprn = c.Int(nullable: false, identity: false),
                        FundingPeriod = c.String(nullable: false, maxLength: 50),
                        Type = c.String(nullable: false, maxLength: 30),
                    CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.Ukprn);
            
        }
        
        public override void Down()
        {
            DropTable("Operations.FundingReportProvider");
        }
    }
}
