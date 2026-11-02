namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ChangeKeyOnClaimReconciliationAllocationGroupFsp : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropIndex("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", new[] { "ClaimReconciliationAllocationGroupCode" });
            DropPrimaryKey("PerformanceManagement.ClaimReconciliationAllocationGroupFsp");
            AlterColumn("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "ClaimReconciliationAllocationGroupCode", c => c.String(maxLength: 30));
            AddPrimaryKey("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "FspCode");
            CreateIndex("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "ClaimReconciliationAllocationGroupCode");
            AddForeignKey("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup", "ClaimReconciliationAllocationGroupCode");
        }
        
        public override void Down()
        {
            DropForeignKey("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropIndex("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", new[] { "ClaimReconciliationAllocationGroupCode" });
            DropPrimaryKey("PerformanceManagement.ClaimReconciliationAllocationGroupFsp");
            AlterColumn("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "ClaimReconciliationAllocationGroupCode", c => c.String(nullable: false, maxLength: 30));
            AddPrimaryKey("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", new[] { "ClaimReconciliationAllocationGroupCode", "FspCode" });
            CreateIndex("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "ClaimReconciliationAllocationGroupCode");
            AddForeignKey("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup", "ClaimReconciliationAllocationGroupCode", cascadeDelete: true);
        }
    }
}
