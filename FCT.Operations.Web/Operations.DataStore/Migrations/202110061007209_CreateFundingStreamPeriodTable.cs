namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateFundingStreamPeriodTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.FundingStreamPeriod",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                        PeriodTypeCode = c.String(nullable: false, maxLength: 50),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.FundingStreamPeriodCode);
            
        }
        
        public override void Down()
        {
            DropTable("Operations.FundingStreamPeriod");
        }
    }
}
