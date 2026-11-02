namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateFundingStreamPeriod : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "DocumentsDomain.FundingStreamPeriod",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                        DisplayName = c.String(nullable: false, maxLength: 100),
                        DisplayOrder = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.FundingStreamPeriodCode);
            
        }
        
        public override void Down()
        {
            DropTable("DocumentsDomain.FundingStreamPeriod");
        }
    }
}
