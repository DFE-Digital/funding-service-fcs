namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddIndexIX_FundingStreamPeriodCodePeriodToTableSubnominalAggregation : DbMigration
    {
        public override void Up()
        {
            DropIndex("PaymentGeneration.SubnominalAggregation", new[] { "FundingStreamPeriodCode" });
            CreateIndex("PaymentGeneration.SubnominalAggregation", new[] { "FundingStreamPeriodCode", "Period" }, name: "IX_FundingStreamPeriodCodePeriod");
        }
        
        public override void Down()
        {
            DropIndex("PaymentGeneration.SubnominalAggregation", "IX_FundingStreamPeriodCodePeriod");
            CreateIndex("PaymentGeneration.SubnominalAggregation", "FundingStreamPeriodCode");
        }
    }
}
