namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class OverDeliveryLimitPercentageNowNullable : DbMigration
    {
        public override void Up()
        {
            AlterColumn("PerformanceManagement.ClaimReconciliationBehaviour", "OverDeliveryLimitPercentage", c => c.Decimal(precision: 18, scale: 2));
        }
        
        public override void Down()
        {
            AlterColumn("PerformanceManagement.ClaimReconciliationBehaviour", "OverDeliveryLimitPercentage", c => c.Decimal(nullable: false, precision: 18, scale: 2));
        }
    }
}
