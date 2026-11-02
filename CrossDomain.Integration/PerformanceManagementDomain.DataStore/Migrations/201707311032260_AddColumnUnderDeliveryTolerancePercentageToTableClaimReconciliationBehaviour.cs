namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnUnderDeliveryTolerancePercentageToTableClaimReconciliationBehaviour : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.ClaimReconciliationBehaviour", "UnderDeliveryTolerancePercentage", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.ClaimReconciliationBehaviour", "UnderDeliveryTolerancePercentage");
        }
    }
}
