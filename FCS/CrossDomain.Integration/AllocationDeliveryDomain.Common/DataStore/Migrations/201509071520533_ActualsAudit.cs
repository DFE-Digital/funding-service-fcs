namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ActualsAudit : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.AllocationDeliverablePeriodActualAudit",
                c => new
                    {
                        RecordedPeriod = c.Int(nullable: false),
                        OrganisationId = c.String(nullable: false, maxLength: 10),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                        UopCode = c.String(nullable: false, maxLength: 100),
                        DeliverableCode = c.Int(nullable: false),
                        Period = c.String(nullable: false, maxLength: 6),
                        ContractAllocationNumber = c.String(maxLength: 20),
                        ContractNumber = c.String(maxLength: 20),
                        ContractVersionNumber = c.Int(nullable: false),
                        ContractSubVersionNumber = c.Int(nullable: false),
                        AllocationStartDate = c.DateTime(nullable: false, precision: 7, storeType: "datetime2"),
                        AllocationEndDate = c.DateTime(nullable: false, precision: 7, storeType: "datetime2"),
                        Ukprn = c.String(maxLength: 8),
                        PeriodTypeCode = c.String(maxLength: 2),
                        ActualVolume = c.Long(nullable: false),
                        ActualValue = c.Double(nullable: false),
                        CollectionReturnCode = c.String(),
                        CollectionType = c.String(),
                        ParentDeliverableCode = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.RecordedPeriod, t.OrganisationId, t.FundingStreamPeriodCode, t.UopCode, t.DeliverableCode, t.Period });
        }
        
        public override void Down()
        {
            DropTable("MonitoringDeliverables.AllocationDeliverablePeriodActualAudit");
        }
    }
}
