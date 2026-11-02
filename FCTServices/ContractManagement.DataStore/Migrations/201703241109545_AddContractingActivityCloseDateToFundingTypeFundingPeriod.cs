namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddContractingActivityCloseDateToFundingTypeFundingPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "ContractingActivityCloseDate", c => c.DateTime());
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "ContractingActivityCloseDate");
        }
    }
}
