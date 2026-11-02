namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AllocationUnderTerminationMigration : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.AllocationUnderTermination",
                c => new
                    {
                        ContractAllocationNumber = c.String(nullable: false, maxLength: 50),
                        TerminationDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.ContractAllocationNumber);
            
        }
        
        public override void Down()
        {
            DropTable("MonitoringDeliverables.AllocationUnderTermination");
        }
    }
}
