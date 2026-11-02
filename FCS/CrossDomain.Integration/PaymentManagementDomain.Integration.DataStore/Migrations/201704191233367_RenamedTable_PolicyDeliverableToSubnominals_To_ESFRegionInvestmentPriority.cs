namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RenamedTable_PolicyDeliverableToSubnominals_To_ESFRegionInvestmentPriority : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PolicyCache.ESFRegionInvestmentPriority",
                c => new
                    {
                        RegionType = c.String(nullable: false, maxLength: 128),
                        InvestmentPriority = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubnominalCode = c.String(nullable: false),
                        CreatedDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => new { t.RegionType, t.InvestmentPriority });
            
            DropTable("PolicyCache.PolicyFundingStreamPeriodSubnominal");
        }
        
        public override void Down()
        {
            CreateTable(
                "PolicyCache.PolicyFundingStreamPeriodSubnominal",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 128),
                        RegionType = c.String(nullable: false, maxLength: 128),
                        InvestmentPriority = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubnominalCode = c.String(nullable: false),
                        CreatedDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => new { t.FundingStreamPeriodCode, t.RegionType, t.InvestmentPriority });
            
            DropTable("PolicyCache.ESFRegionInvestmentPriority");
        }
    }
}
