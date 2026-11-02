namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class TotalValue_Column_OnPaymentBatchFeedItem : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentGeneration.PaymentBatchFeedItem", "TotalValue", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("PaymentGeneration.PaymentBatchFeedItem", "TotalValue");
        }
    }
}
