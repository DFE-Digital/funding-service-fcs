namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddOverDeliveryLimitPercentageToClaimReconciliationBehaviour : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.ClaimReconciliationBehaviour", "OverDeliveryLimitPercentage", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.ClaimReconciliationBehaviour", "OverDeliveryLimitPercentage");
        }
    }
}
