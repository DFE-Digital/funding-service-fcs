namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CurrentViewActuals : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.CurrentViewActual",
                c => new
                    {
                        Ukprn = c.String(maxLength: 8),
                        ContractNumber = c.String(maxLength: 20),
                        ContractVersion = c.Int(nullable: false),
                        ContractSubVersion = c.Int(nullable: false),
                        AllocationStartDate = c.DateTime(nullable: false, precision: 7, storeType: "datetime2"),
                        AllocationEndDate = c.DateTime(nullable: false, precision: 7, storeType: "datetime2"),
                        CollectionReturnCode = c.String(maxLength: 10),
                        OrganisationId = c.String(nullable: false, maxLength: 10),
                        PeriodTypeCode = c.String(maxLength: 2),
                        Period = c.String(nullable: false, maxLength: 6),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 20),
                        CollectionType = c.String(maxLength: 20),
                        ContractAllocationNumber = c.String(maxLength: 20),
                        UoPCode = c.String(nullable: false, maxLength: 100),
                        DeliverableCode = c.Int(nullable: false),
                        ActualVolume = c.Long(nullable: false),
                        ActualValue = c.Double(nullable: false),
                    })
                .PrimaryKey(t => new { t.OrganisationId, t.Period, t.FundingStreamPeriodCode, t.UoPCode, t.DeliverableCode });
        }
        
        public override void Down()
        {
            DropTable("MonitoringDeliverables.CurrentViewActual");
        }
    }
}
