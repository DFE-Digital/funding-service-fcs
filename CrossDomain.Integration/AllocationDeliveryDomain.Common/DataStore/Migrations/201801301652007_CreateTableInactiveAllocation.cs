namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableInactiveAllocation : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.InactiveAllocation",
                c => new
                    {
                        ContractAllocationNumber = c.String(nullable: false, maxLength: 50),
                        Reason = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.ContractAllocationNumber);
            
        }
        
        public override void Down()
        {
            DropTable("MonitoringDeliverables.InactiveAllocation");
        }
    }
}
