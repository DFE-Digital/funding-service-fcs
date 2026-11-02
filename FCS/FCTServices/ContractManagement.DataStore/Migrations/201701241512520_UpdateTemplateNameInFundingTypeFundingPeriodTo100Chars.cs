namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UpdateTemplateNameInFundingTypeFundingPeriodTo100Chars : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.FundingTypeFundingPeriod", "TemplateName", c => c.String(maxLength: 100));
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.FundingTypeFundingPeriod", "TemplateName", c => c.String());
        }
    }
}
