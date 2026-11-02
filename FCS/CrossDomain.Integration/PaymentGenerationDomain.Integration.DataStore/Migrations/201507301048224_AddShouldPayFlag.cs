namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddShouldPayFlag : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentGeneration.FundingStreamPeriod", "ShouldPay", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PaymentGeneration.FundingStreamPeriod", "ShouldPay");
        }
    }
}
