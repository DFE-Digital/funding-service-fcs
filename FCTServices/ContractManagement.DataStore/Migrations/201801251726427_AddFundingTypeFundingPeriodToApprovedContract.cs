namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFundingTypeFundingPeriodToApprovedContract : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.ApprovedContract", "FundingType", c => c.String(maxLength: 100));
            AddColumn("ContractManagement.ApprovedContract", "FundingPeriod", c => c.String(maxLength: 100));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.ApprovedContract", "FundingPeriod");
            DropColumn("ContractManagement.ApprovedContract", "FundingType");
        }
    }
}
