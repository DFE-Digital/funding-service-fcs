namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateIndexOnAuditTableForContractAllocationNumberAndCollectionReturnPeriod : DbMigration
    {
        public override void Up()
        {
            CreateIndex("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", new[] { "ContractAllocationNumber", "CollectionReturnPeriod" }, name: "IX_AllocationDeliverablePeriodActualAudit_ContractAllocationNumberCollectionReturnPeriod");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit", "IX_AllocationDeliverablePeriodActualAudit_ContractAllocationNumberCollectionReturnPeriod");
        }
    }
}
