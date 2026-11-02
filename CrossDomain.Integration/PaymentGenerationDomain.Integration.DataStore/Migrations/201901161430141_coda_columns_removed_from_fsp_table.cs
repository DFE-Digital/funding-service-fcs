namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class coda_columns_removed_from_fsp_table : DbMigration
    {
        public override void Up()
        {
            DropColumn("PaymentGeneration.FundingStreamPeriod", "DummyAccountCode");
            DropColumn("PaymentGeneration.FundingStreamPeriod", "ControlAccountCode");
            DropColumn("PaymentGeneration.FundingStreamPeriod", "Element1DefaultValue");
        }
        
        public override void Down()
        {
            AddColumn("PaymentGeneration.FundingStreamPeriod", "Element1DefaultValue", c => c.String(nullable: false, maxLength: 100));
            AddColumn("PaymentGeneration.FundingStreamPeriod", "ControlAccountCode", c => c.Int(nullable: false));
            AddColumn("PaymentGeneration.FundingStreamPeriod", "DummyAccountCode", c => c.String(nullable: false, maxLength: 100));
        }
    }
}
