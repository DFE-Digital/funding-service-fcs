namespace ContractManagement.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddProcessingStateAndContractNumberColumns : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.EngagementEvent", "ProcessingState", c => c.Int(nullable: false));
            AddColumn("ContractManagement.EngagementEvent", "ContractNumber", c => c.String(maxLength: 20));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.EngagementEvent", "ContractNumber");
            DropColumn("ContractManagement.EngagementEvent", "ProcessingState");
        }
    }
}
