namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class MakeActualVolumeNullable : DbMigration
    {
        public override void Up()
        {
            AlterColumn("MonitoringDeliverables.SummarisedActual", "ActualVolume", c => c.Int());
        }
        
        public override void Down()
        {
            AlterColumn("MonitoringDeliverables.SummarisedActual", "ActualVolume", c => c.Int(nullable: false));
        }
    }
}
