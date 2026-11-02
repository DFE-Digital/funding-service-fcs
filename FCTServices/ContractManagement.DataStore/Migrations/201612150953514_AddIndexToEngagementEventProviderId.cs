namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddIndexToEngagementEventProviderId : DbMigration
    {
        public override void Up()
        {
            CreateIndex("ContractManagement.EngagementEvent", "ProviderId", name: "IX_EngagementEvent_ProviderId");
        }
        
        public override void Down()
        {
            DropIndex("ContractManagement.EngagementEvent", "IX_EngagementEvent_ProviderId");
        }
    }
}
