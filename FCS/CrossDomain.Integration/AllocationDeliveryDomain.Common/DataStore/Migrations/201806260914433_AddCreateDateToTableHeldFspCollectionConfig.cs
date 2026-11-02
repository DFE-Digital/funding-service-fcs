namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCreateDateToTableHeldFspCollectionConfig : DbMigration
    {
        public override void Up()
        {
            AddColumn("MonitoringDeliverables.HeldFspCollectionConfig", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }

        public override void Down()
        {
            DropColumn("MonitoringDeliverables.HeldFspCollectionConfig", "CreatedDate");
        }
    }
}
