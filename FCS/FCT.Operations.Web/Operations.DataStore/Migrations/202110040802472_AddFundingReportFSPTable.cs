namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddFundingReportFSPTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.FundingReportFSP",
                c => new
                    {
                        FspCode = c.String(nullable: false, maxLength: 100),
                        Order = c.Int(nullable: false),
                        FundingPeriod = c.String(nullable: false, maxLength: 100),
                        Description = c.String(nullable: false, maxLength: 150),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.FspCode);
            
        }
        
        public override void Down()
        {
            DropTable("Operations.FundingReportFSP");
        }
    }
}
