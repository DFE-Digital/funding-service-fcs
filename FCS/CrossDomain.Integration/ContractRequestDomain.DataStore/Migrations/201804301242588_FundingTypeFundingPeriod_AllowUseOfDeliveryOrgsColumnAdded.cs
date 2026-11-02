namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FundingTypeFundingPeriod_AllowUseOfDeliveryOrgsColumnAdded : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractRequest.FundingTypeFundingPeriod", "AllowUseOfDeliveryOrgs", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("ContractRequest.FundingTypeFundingPeriod", "AllowUseOfDeliveryOrgs");
        }
    }
}
