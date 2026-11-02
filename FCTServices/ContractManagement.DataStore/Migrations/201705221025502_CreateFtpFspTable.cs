namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateFtpFspTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.FundingTypePeriodFundingStreamPeriod",
                c => new
                    {
                        FundingTypeCode = c.String(nullable: false, maxLength: 100),
                        FundingPeriodCode = c.String(nullable: false, maxLength: 100),
                        FundingStreamCode = c.String(nullable: false, maxLength: 100),
                    })
                .PrimaryKey(t => new { t.FundingTypeCode, t.FundingPeriodCode, t.FundingStreamCode });
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.FundingTypePeriodFundingStreamPeriod");
        }
    }
}
