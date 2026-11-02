namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddContractNumberAndCreatedDateToAllocationUnderTerminationTable : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.AllocationUnderTermination", "ContractNumber", c => c.String(nullable: false, maxLength: 20));
            CreateIndex("MonitoringDeliverables.AllocationUnderTermination", "ContractNumber");
            AddColumn("MonitoringDeliverables.AllocationUnderTermination", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }
        
        public override void Down()
        {
            DropColumn("MonitoringDeliverables.AllocationUnderTermination", "CreatedDate");
            DropIndex("MonitoringDeliverables.AllocationUnderTermination", new[] { "ContractNumber" });
            DropColumn("MonitoringDeliverables.AllocationUnderTermination", "ContractNumber");
        }
    }
}
