namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class ChangeShouldPay_to_GeneratePayments : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentGeneration.FundingStreamPeriod", "GeneratePayments", c => c.Boolean(nullable: false, defaultValue: true));
            DropColumn("PaymentGeneration.FundingStreamPeriod", "ShouldPay");
        }
        
        public override void Down()
        {
            AddColumn("PaymentGeneration.FundingStreamPeriod", "ShouldPay", c => c.Boolean(nullable: false));
            DropColumn("PaymentGeneration.FundingStreamPeriod", "GeneratePayments");
        }
    }
}
