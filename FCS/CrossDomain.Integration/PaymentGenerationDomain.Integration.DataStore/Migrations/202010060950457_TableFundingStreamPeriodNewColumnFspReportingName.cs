namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class TableFundingStreamPeriodNewColumnFspReportingName : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentGeneration.FundingStreamPeriod", "FspReportingName", c => c.String(maxLength: 100));
        }
        
        public override void Down()
        {
            DropColumn("PaymentGeneration.FundingStreamPeriod", "FspReportingName");
        }
    }
}
