namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CleardownAllocationUnderTerminationTable : DbMigration
    {
        public override void Up()
        {
            Sql(@"DELETE FROM [MonitoringDeliverables].[AllocationUnderTermination]");
        }
        
        public override void Down()
        {
            // do nothing
        }
    }
}
