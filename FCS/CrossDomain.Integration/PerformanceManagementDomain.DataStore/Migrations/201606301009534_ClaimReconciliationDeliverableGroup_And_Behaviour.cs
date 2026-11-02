namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ClaimReconciliationDeliverableGroup_And_Behaviour : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.ClaimReconciliationBehaviour",
                c => new
                    {
                        ClaimCollectionCode = c.String(nullable: false, maxLength: 30),
                        ClaimReconciliationAllocationGroupCode = c.String(nullable: false, maxLength: 30),
                        IsReconciliationPayable = c.Boolean(nullable: false),
                        IsReconciliationUnderDeliverery = c.Boolean(nullable: false),
                        IsReconciliationOverDeliverery = c.Boolean(nullable: false),
                        OverDeliveryDeMinimis = c.Decimal(nullable: false, precision: 18, scale: 2),
                        UnderDeliveryDeMinimis = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => new { t.ClaimCollectionCode, t.ClaimReconciliationAllocationGroupCode })
                .ForeignKey("PerformanceManagement.ClaimCollection", t => t.ClaimCollectionCode, cascadeDelete: true)
                .ForeignKey("PerformanceManagement.ClaimReconciliationAllocationGroup", t => t.ClaimReconciliationAllocationGroupCode, cascadeDelete: true)
                .Index(t => t.ClaimCollectionCode)
                .Index(t => t.ClaimReconciliationAllocationGroupCode);
            
            CreateTable(
                "PerformanceManagement.ClaimReconciliationDeliverableGroup",
                c => new
                    {
                        ClaimReconciliationDeliverableGroupCode = c.String(nullable: false, maxLength: 30),
                    })
                .PrimaryKey(t => t.ClaimReconciliationDeliverableGroupCode);
            
        }
        
        public override void Down()
        {
            DropForeignKey("PerformanceManagement.ClaimReconciliationBehaviour", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropForeignKey("PerformanceManagement.ClaimReconciliationBehaviour", "ClaimCollectionCode", "PerformanceManagement.ClaimCollection");
            DropIndex("PerformanceManagement.ClaimReconciliationBehaviour", new[] { "ClaimReconciliationAllocationGroupCode" });
            DropIndex("PerformanceManagement.ClaimReconciliationBehaviour", new[] { "ClaimCollectionCode" });
            DropTable("PerformanceManagement.ClaimReconciliationDeliverableGroup");
            DropTable("PerformanceManagement.ClaimReconciliationBehaviour");
        }
    }
}
