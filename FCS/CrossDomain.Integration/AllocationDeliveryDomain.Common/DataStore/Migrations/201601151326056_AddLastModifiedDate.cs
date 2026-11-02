namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddLastModifiedDate : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.CurrentViewActual", "LastModifiedDate", c => c.DateTime(precision: 7, storeType: "datetime2"));
        }
        
        public override void Down()
        {
            DropColumn("MonitoringDeliverables.CurrentViewActual", "LastModifiedDate");
        }
    }
}
