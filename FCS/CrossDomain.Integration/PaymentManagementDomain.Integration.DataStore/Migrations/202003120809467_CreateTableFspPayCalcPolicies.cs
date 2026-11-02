namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableFspPayCalcPolicies : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PolicyCache.FundingStreamPeriodPayCalcPolicy",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 128),
                        CalcPolicyVersion = c.Int(nullable: false),
                        PaymentCappingPeriod = c.Int(nullable: false),
                        OverDeliveryLimit = c.Int(),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.FundingStreamPeriodCode, t.CalcPolicyVersion })
                .ForeignKey("PolicyCache.PolicyFundingStreamPeriod", t => t.FundingStreamPeriodCode, cascadeDelete: true)
                .Index(t => t.FundingStreamPeriodCode);
            
        }
        
        public override void Down()
        {
            DropForeignKey("PolicyCache.FundingStreamPeriodPayCalcPolicy", "FundingStreamPeriodCode", "PolicyCache.PolicyFundingStreamPeriod");
            DropIndex("PolicyCache.FundingStreamPeriodPayCalcPolicy", new[] { "FundingStreamPeriodCode" });
            DropTable("PolicyCache.FundingStreamPeriodPayCalcPolicy");
        }
    }
}
