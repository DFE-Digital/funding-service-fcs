namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FspDeliverableClaim_FK_Change : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropIndex("PerformanceManagement.FspDeliverableClaim", new[] { "ClaimReconciliationAllocationGroupCode" });
            AddColumn("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationDeliverableGroupCode", c => c.String(maxLength: 30));
            CreateIndex("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationDeliverableGroupCode");
            AddForeignKey("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationDeliverableGroupCode", "PerformanceManagement.ClaimReconciliationDeliverableGroup", "ClaimReconciliationDeliverableGroupCode");
            DropColumn("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode");
        }
        
        public override void Down()
        {
            AddColumn("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", c => c.String(maxLength: 30));
            DropForeignKey("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationDeliverableGroupCode", "PerformanceManagement.ClaimReconciliationDeliverableGroup");
            DropIndex("PerformanceManagement.FspDeliverableClaim", new[] { "ClaimReconciliationDeliverableGroupCode" });
            DropColumn("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationDeliverableGroupCode");
            CreateIndex("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode");
            AddForeignKey("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup", "ClaimReconciliationAllocationGroupCode");
        }
    }
}
