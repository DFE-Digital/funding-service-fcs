namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AllowNullOrEmptyProviderId : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.EngagementEvent", "ProviderId", c => c.String(maxLength: 10));
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.EngagementEvent", "ProviderId", c => c.String(nullable: false, maxLength: 10));
        }
    }
}
