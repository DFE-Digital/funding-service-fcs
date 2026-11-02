namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MakeAllocationEndDateColumnNullable : DbMigration
    {
        public override void Up()
        {
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "AllocationEndDate", c => c.DateTime(precision: 7, storeType: "datetime2"));
        }
        
        public override void Down()
        {
            AlterColumn("MonitoringDeliverables.AllocationDeliverablePeriod", "AllocationEndDate", c => c.DateTime(nullable: false, precision: 7, storeType: "datetime2"));
        }
    }
}
