namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreatePaymentBatchFeedTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PaymentGeneration.PaymentBatchFeedItem",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Identifier = c.Guid(nullable: false),
                        FundingStreamPeriod = c.String(nullable: false, maxLength: 20),
                        PaymentPeriod = c.String(nullable: false, maxLength: 10),
                        CensusEndDate = c.DateTime(nullable: false),
                        PaymentLineCount = c.Int(nullable: false),
                        LinkCodeSuffix = c.String(nullable: false, maxLength: 2),
                        CorporatePaymentBatchBytes = c.Binary(),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                    })
                .PrimaryKey(t => t.Id)
                .Index(t => new { t.FundingStreamPeriod, t.PaymentPeriod, t.CensusEndDate, t.LinkCodeSuffix }, unique: true, name: "IX_PaymentBatchFeedItemNaturalKey");
            
        }
        
        public override void Down()
        {
            DropIndex("PaymentGeneration.PaymentBatchFeedItem", "IX_PaymentBatchFeedItemNaturalKey");
            DropTable("PaymentGeneration.PaymentBatchFeedItem");
        }
    }
}
