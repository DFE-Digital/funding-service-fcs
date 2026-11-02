namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MakeTableFundingStreamColumnFinanceShortCodeNullable : DbMigration
    {
        public override void Up()
        {
            AlterColumn("PaymentGeneration.FundingStream", "FinanceShortCode", c => c.String(maxLength: 100));
        }
        
        public override void Down()
        {
            AlterColumn("PaymentGeneration.FundingStream", "FinanceShortCode", c => c.String(nullable: false, maxLength: 100));
        }
    }
}
