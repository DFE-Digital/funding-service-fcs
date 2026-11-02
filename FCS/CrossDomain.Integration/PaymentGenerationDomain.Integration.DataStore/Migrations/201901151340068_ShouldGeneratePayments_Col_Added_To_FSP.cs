namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ShouldGeneratePayments_Col_Added_To_FSP : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentGeneration.FundingStreamPeriod", "ShouldGeneratePayments", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PaymentGeneration.FundingStreamPeriod", "ShouldGeneratePayments");
        }
    }
}
