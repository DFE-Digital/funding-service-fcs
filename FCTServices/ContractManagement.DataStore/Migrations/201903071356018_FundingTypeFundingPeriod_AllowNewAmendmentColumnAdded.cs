namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FundingTypeFundingPeriod_AllowNewAmendmentColumnAdded : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "AllowNewAmendment", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "AllowNewAmendment");
        }
    }
}
