namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateFundingTypeFundingPeriod : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.FundingTypeFundingPeriod",
                c => new
                    {
                        FundingTypeCode = c.String(nullable: false, maxLength: 100),
                        FundingPeriodName = c.String(nullable: false, maxLength: 100),
                        ApprovalType = c.String(maxLength: 100),
                    })
                .PrimaryKey(t => new { t.FundingTypeCode, t.FundingPeriodName });
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.FundingTypeFundingPeriod");
        }
    }
}
