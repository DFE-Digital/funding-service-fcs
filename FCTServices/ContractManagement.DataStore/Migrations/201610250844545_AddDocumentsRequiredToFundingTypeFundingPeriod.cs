namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddDocumentsRequiredToFundingTypeFundingPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "DocumentsRequired", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "DocumentsRequired");
        }
    }
}
