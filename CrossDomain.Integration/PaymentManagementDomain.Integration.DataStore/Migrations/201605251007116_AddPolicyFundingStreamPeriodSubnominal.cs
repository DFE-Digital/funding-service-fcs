namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddPolicyFundingStreamPeriodSubnominal : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PolicyCache.PolicyFundingStreamPeriodSubnominal",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 128),
                        RegionType = c.String(nullable: false, maxLength: 128),
                        InvestmentPriority = c.Decimal(nullable: false, precision: 18, scale: 2),
                        SubnominalCode = c.String(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETDATE()"),
                    })
                .PrimaryKey(t => new { t.FundingStreamPeriodCode, t.RegionType, t.InvestmentPriority });
        }

        public override void Down()
        {
            DropTable("PolicyCache.PolicyFundingStreamPeriodSubnominal");
        }
    }
}
