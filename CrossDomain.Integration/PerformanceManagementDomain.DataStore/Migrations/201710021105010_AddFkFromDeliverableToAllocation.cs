namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFkFromDeliverableToAllocation : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("PerformanceManagement.ContractAllocationDeliverable");
            AlterColumn("PerformanceManagement.ContractAllocationDeliverable", "ContractAllocationNumber", c => c.String(nullable: false, maxLength: 30));
            AddPrimaryKey("PerformanceManagement.ContractAllocationDeliverable", new[] { "ContractAllocationNumber", "DeliverableCode" });
            CreateIndex("PerformanceManagement.ContractAllocationDeliverable", "ContractAllocationNumber");
            AddForeignKey("PerformanceManagement.ContractAllocationDeliverable", "ContractAllocationNumber", "PerformanceManagement.ContractAllocation", "AllocationNumber", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("PerformanceManagement.ContractAllocationDeliverable", "ContractAllocationNumber", "PerformanceManagement.ContractAllocation");
            DropIndex("PerformanceManagement.ContractAllocationDeliverable", new[] { "ContractAllocationNumber" });
            DropPrimaryKey("PerformanceManagement.ContractAllocationDeliverable");
            AlterColumn("PerformanceManagement.ContractAllocationDeliverable", "ContractAllocationNumber", c => c.String(nullable: false, maxLength: 20));
            AddPrimaryKey("PerformanceManagement.ContractAllocationDeliverable", new[] { "ContractAllocationNumber", "DeliverableCode" });
        }
    }
}
