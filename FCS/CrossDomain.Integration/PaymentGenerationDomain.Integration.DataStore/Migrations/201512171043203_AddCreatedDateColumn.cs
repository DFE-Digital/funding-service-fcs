namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCreatedDateColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentGeneration.Subnominal", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PaymentGeneration.SubnominalAggregation", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PaymentGeneration.PaymentTimetable", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PaymentGeneration.PaymentTimetableHistory", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PaymentGeneration.FundingStream", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PaymentGeneration.FundingStreamPeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
        
        public override void Down()
        {
            DropColumn("PaymentGeneration.Subnominal", "CreatedDate");
            DropColumn("PaymentGeneration.SubnominalAggregation", "CreatedDate");
            DropColumn("PaymentGeneration.PaymentTimetable", "CreatedDate");
            DropColumn("PaymentGeneration.PaymentTimetableHistory", "CreatedDate");
            DropColumn("PaymentGeneration.FundingStream", "CreatedDate");
            DropColumn("PaymentGeneration.FundingStreamPeriod", "CreatedDate");
        }
    }
}
