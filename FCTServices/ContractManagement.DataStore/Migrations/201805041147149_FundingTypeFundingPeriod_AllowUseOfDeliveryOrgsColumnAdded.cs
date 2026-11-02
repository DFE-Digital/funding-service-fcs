namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FundingTypeFundingPeriod_AllowUseOfDeliveryOrgsColumnAdded : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "AllowUseOfDeliveryOrgs", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "AllowUseOfDeliveryOrgs");
        }
    }
}
