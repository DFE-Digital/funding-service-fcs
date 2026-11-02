namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddAmendmentTemplateToFundingTypeFundingPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "AmendmentTemplate", c => c.String(maxLength: 100));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "AmendmentTemplate");
        }
    }
}
