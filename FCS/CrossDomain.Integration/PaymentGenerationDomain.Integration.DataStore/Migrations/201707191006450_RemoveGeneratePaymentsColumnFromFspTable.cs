namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemoveGeneratePaymentsColumnFromFspTable : DbMigration
    {
        public override void Up()
        {
            DropColumn("PaymentGeneration.FundingStreamPeriod", "GeneratePayments");
        }
        
        public override void Down()
        {
            AddColumn("PaymentGeneration.FundingStreamPeriod", "GeneratePayments", c => c.Boolean(nullable: false));
        }
    }
}
