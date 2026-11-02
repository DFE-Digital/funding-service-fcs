namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ClaimReconciliationBehaviour_ColumnRenames : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.ClaimReconciliationBehaviour", "DoWeReconcileUnderDelivery", c => c.Boolean(nullable: false));
            AddColumn("PerformanceManagement.ClaimReconciliationBehaviour", "DoWeReconcileOverDelivery", c => c.Boolean(nullable: false));
            DropColumn("PerformanceManagement.ClaimReconciliationBehaviour", "IsReconciliationUnderDeliverery");
            DropColumn("PerformanceManagement.ClaimReconciliationBehaviour", "IsReconciliationOverDeliverery");
        }
        
        public override void Down()
        {
            AddColumn("PerformanceManagement.ClaimReconciliationBehaviour", "IsReconciliationOverDeliverery", c => c.Boolean(nullable: false));
            AddColumn("PerformanceManagement.ClaimReconciliationBehaviour", "IsReconciliationUnderDeliverery", c => c.Boolean(nullable: false));
            DropColumn("PerformanceManagement.ClaimReconciliationBehaviour", "DoWeReconcileOverDelivery");
            DropColumn("PerformanceManagement.ClaimReconciliationBehaviour", "DoWeReconcileUnderDelivery");
        }
    }
}
