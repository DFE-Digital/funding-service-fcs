namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateActualsStagingTables : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.ClosedCollection",
                c => new
                    {
                        CollectionType = c.String(nullable: false, maxLength: 20),
                        CollectionReturnCode = c.String(nullable: false, maxLength: 20),
                        ClosedTime = c.DateTime(nullable: false),
                        TotalRowCount = c.Int(nullable: false),
                        RetrievedRowCount = c.Int(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                    })
                .PrimaryKey(t => new { t.CollectionType, t.CollectionReturnCode });
            
            CreateTable(
                "MonitoringDeliverables.SummarisedActual",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        CollectionType = c.String(nullable: false, maxLength: 20),
                        CollectionReturnCode = c.String(nullable: false, maxLength: 20),
                        OrganisationId = c.String(nullable: false, maxLength: 20),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 20),
                        UopCode = c.String(maxLength: 20),
                        Period = c.Int(nullable: false),
                        DeliverableCode = c.Int(nullable: false),
                        ContractAllocationNumber = c.String(maxLength: 20),
                        ActualVolume = c.Int(nullable: false),
                        ActualValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                        DataCollectionsId = c.Int(),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                    })
                .PrimaryKey(t => t.Id)
                .ForeignKey("MonitoringDeliverables.ClosedCollection", t => new { t.CollectionType, t.CollectionReturnCode }, cascadeDelete: true)
                .Index(t => new { t.CollectionType, t.CollectionReturnCode, t.OrganisationId, t.FundingStreamPeriodCode }, name: "IX_SummarisedActual_Actuals_Group")
                .Index(t => new { t.CollectionType, t.CollectionReturnCode, t.OrganisationId, t.FundingStreamPeriodCode, t.UopCode, t.Period, t.DeliverableCode }, unique: true, name: "IX_SummarisedActual_Natural_Key");
            
        }
        
        public override void Down()
        {
            DropForeignKey("MonitoringDeliverables.SummarisedActual", new[] { "CollectionType", "CollectionReturnCode" }, "MonitoringDeliverables.ClosedCollection");
            DropIndex("MonitoringDeliverables.SummarisedActual", "IX_SummarisedActual_Natural_Key");
            DropIndex("MonitoringDeliverables.SummarisedActual", "IX_SummarisedActual_Actuals_Group");
            DropTable("MonitoringDeliverables.SummarisedActual");
            DropTable("MonitoringDeliverables.ClosedCollection");
        }
    }
}
