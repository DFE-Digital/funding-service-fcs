namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FspDeliverableClaim : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.FspDeliverableClaim",
                c => new
                    {
                        FspCode = c.String(nullable: false, maxLength: 30),
                        DeliverableCode = c.Int(nullable: false),
                        AllowClaim = c.Boolean(nullable: false),
                        ClaimReconciliationAllocationGroupCode = c.String(nullable: false, maxLength: 30),
                    })
                .PrimaryKey(t => new { t.FspCode, t.DeliverableCode })
                .ForeignKey("PerformanceManagement.ClaimReconciliationAllocationGroup", t => t.ClaimReconciliationAllocationGroupCode, cascadeDelete: true)
                .Index(t => t.ClaimReconciliationAllocationGroupCode);
            
        }
        
        public override void Down()
        {
            DropForeignKey("PerformanceManagement.FspDeliverableClaim", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropIndex("PerformanceManagement.FspDeliverableClaim", new[] { "ClaimReconciliationAllocationGroupCode" });
            DropTable("PerformanceManagement.FspDeliverableClaim");
        }
    }
}
