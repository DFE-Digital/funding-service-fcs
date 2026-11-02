namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddPublicationCloseDateToClaimReconciliationBehaviour : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.ClaimReconciliationBehaviour", "PublicationCloseDate", c => c.DateTime());
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.ClaimReconciliationBehaviour", "PublicationCloseDate");
        }
    }
}
