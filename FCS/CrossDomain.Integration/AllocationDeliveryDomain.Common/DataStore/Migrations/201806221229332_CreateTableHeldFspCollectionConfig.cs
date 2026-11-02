namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableHeldFspCollectionConfig : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.HeldFspCollectionConfig",
                c => new
                    {
                        MultipleCollectionGroupId = c.Int(nullable: false),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 20),
                        CollectionType = c.String(nullable: false, maxLength: 20),
                        CollectionReturnCode = c.String(nullable: false, maxLength: 10),
                    })
                .PrimaryKey(t => new { t.MultipleCollectionGroupId, t.FundingStreamPeriodCode, t.CollectionType });
            
        }
        
        public override void Down()
        {
            DropTable("MonitoringDeliverables.HeldFspCollectionConfig");
        }
    }
}
