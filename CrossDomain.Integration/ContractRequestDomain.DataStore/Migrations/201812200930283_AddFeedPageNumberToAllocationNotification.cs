namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddFeedPageNumberToAllocationNotification : DbMigration
    {
        public override void Up()
        {
            Sql("DELETE FROM ContractRequest.AllocationNotification");

            AddColumn("ContractRequest.AllocationNotification", "FeedPageNumber", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("ContractRequest.AllocationNotification", "FeedPageNumber");
        }
    }
}
