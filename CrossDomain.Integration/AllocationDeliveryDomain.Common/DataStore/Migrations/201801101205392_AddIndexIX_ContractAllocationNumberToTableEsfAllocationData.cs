namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddIndexIX_ContractAllocationNumberToTableEsfAllocationData : DbMigration
    {
        public override void Up()
        {
            CreateIndex("MonitoringDeliverables.EsfAllocationData", "ContractAllocationNumber");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.EsfAllocationData", new[] { "ContractAllocationNumber" });
        }
    }
}
