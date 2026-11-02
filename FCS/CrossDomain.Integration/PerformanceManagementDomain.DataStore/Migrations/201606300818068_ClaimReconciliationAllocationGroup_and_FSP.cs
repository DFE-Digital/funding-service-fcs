namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ClaimReconciliationAllocationGroup_and_FSP : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.ClaimReconciliationAllocationGroupFsp",
                c => new
                    {
                        ClaimReconciliationAllocationGroupCode = c.String(nullable: false, maxLength: 30),
                        FspCode = c.String(nullable: false, maxLength: 30),
                    })
                .PrimaryKey(t => new { t.ClaimReconciliationAllocationGroupCode, t.FspCode })
                .ForeignKey("PerformanceManagement.ClaimReconciliationAllocationGroup", t => t.ClaimReconciliationAllocationGroupCode, cascadeDelete: true)
                .Index(t => t.ClaimReconciliationAllocationGroupCode);
            
            CreateTable(
                "PerformanceManagement.ClaimReconciliationAllocationGroup",
                c => new
                    {
                        ClaimReconciliationAllocationGroupCode = c.String(nullable: false, maxLength: 30),
                        GroupName = c.String(maxLength: 100),
                    })
                .PrimaryKey(t => t.ClaimReconciliationAllocationGroupCode);
            
        }
        
        public override void Down()
        {
            DropForeignKey("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropIndex("PerformanceManagement.ClaimReconciliationAllocationGroupFsp", new[] { "ClaimReconciliationAllocationGroupCode" });
            DropTable("PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropTable("PerformanceManagement.ClaimReconciliationAllocationGroupFsp");
        }
    }
}
