namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableFundingStreamPeriodCappingPeriodPayCalcPolicy : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PolicyCache.FundingStreamPeriodCappingPeriodPayCalcPolicy",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 128),
                        CalcPolicyVersion = c.Int(nullable: false),
                        CappingPeriod = c.Int(nullable: false),
                        OverDeliveryLimit = c.Decimal(nullable: false, precision: 18, scale: 2),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.FundingStreamPeriodCode, t.CalcPolicyVersion, t.CappingPeriod })
                .ForeignKey("PolicyCache.FundingStreamPeriodPayCalcPolicy", t => new { t.FundingStreamPeriodCode, t.CalcPolicyVersion }, cascadeDelete: true)
                .Index(t => new { t.FundingStreamPeriodCode, t.CalcPolicyVersion });
            
        }
        
        public override void Down()
        {
            DropForeignKey("PolicyCache.FundingStreamPeriodCappingPeriodPayCalcPolicy", new[] { "FundingStreamPeriodCode", "CalcPolicyVersion" }, "PolicyCache.FundingStreamPeriodPayCalcPolicy");
            DropIndex("PolicyCache.FundingStreamPeriodCappingPeriodPayCalcPolicy", new[] { "FundingStreamPeriodCode", "CalcPolicyVersion" });
            DropTable("PolicyCache.FundingStreamPeriodCappingPeriodPayCalcPolicy");
        }
    }
}
