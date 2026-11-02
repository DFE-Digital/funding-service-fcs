namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FspDeliverableClaim_Column_NotRequired : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropIndex("PerformanceManagement.FspDeliverableClaim", new[] { "ClaimReconciliationAllocationGroupCode" });
            AlterColumn("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", c => c.String(maxLength: 30));
            CreateIndex("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode");
            AddForeignKey("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup", "ClaimReconciliationAllocationGroupCode");
        }
        
        public override void Down()
        {
            DropForeignKey("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropIndex("PerformanceManagement.FspDeliverableClaim", new[] { "ClaimReconciliationAllocationGroupCode" });
            AlterColumn("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", c => c.String(nullable: false, maxLength: 30));
            CreateIndex("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode");
            AddForeignKey("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup", "ClaimReconciliationAllocationGroupCode", cascadeDelete: true);
        }
    }
}
