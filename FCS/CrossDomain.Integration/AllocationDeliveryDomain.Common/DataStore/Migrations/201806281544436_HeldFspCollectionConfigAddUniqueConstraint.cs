namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class HeldFspCollectionConfigAddUniqueConstraint : DbMigration
    {
        public override void Up()
        {
            CreateIndex("MonitoringDeliverables.HeldFspCollectionConfig", new[] { "FundingStreamPeriodCode", "CollectionType", "CollectionReturnCode" }, unique: true, name: "IX_HeldFspCollectionConfig_Unique");
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.HeldFspCollectionConfig", "IX_HeldFspCollectionConfig_Unique");
        }
    }
}
