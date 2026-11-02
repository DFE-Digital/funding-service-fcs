namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class TableClaimReconciliationBehaviourNewColumnUnderDeliveryRecoveryAmount : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.ClaimReconciliationBehaviour", "UnderDeliveryRecoveryAmount", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.ClaimReconciliationBehaviour", "UnderDeliveryRecoveryAmount");
        }
    }
}
