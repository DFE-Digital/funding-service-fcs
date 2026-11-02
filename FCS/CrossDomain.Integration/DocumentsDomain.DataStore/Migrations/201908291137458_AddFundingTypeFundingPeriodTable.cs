namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFundingTypeFundingPeriodTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "DocumentsDomain.FundingTypeFundingPeriod",
                c => new
                    {
                        FundingTypeCode = c.String(nullable: false, maxLength: 100),
                        FundingPeriodName = c.String(nullable: false, maxLength: 100),
                        OnlyGenerateFundingAgreementForNewOrUpdatedAllocations = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => new { t.FundingTypeCode, t.FundingPeriodName });
            
        }
        
        public override void Down()
        {
            DropTable("DocumentsDomain.FundingTypeFundingPeriod");
        }
    }
}
