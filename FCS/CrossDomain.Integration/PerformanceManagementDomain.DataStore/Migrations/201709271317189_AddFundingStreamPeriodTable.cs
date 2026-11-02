namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFundingStreamPeriodTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.FundingStreamPeriod",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 20),
                        IsPayOnProfile = c.Boolean(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"),
                    })
                    .PrimaryKey(t => t.FundingStreamPeriodCode);
            
        }
        
        public override void Down()
        {
            DropTable("PerformanceManagement.FundingStreamPeriod");
        }
    }
}
