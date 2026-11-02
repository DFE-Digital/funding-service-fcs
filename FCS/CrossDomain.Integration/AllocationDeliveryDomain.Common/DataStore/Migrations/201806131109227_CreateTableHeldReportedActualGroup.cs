namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableHeldReportedActualGroup : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.HeldReportedActualGroup",
                c => new
                    {
                        PartitionKey = c.String(nullable: false, maxLength: 200),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 20),
                        OrganisationIdentifier = c.String(nullable: false, maxLength: 10),
                        UoPCode = c.String(maxLength: 100),
                        CollectionType = c.String(nullable: false, maxLength: 20),
                        CollectionReturnCode = c.String(nullable: false, maxLength: 10),
                    })
                .PrimaryKey(t => t.PartitionKey)
                .Index(t => new { t.FundingStreamPeriodCode, t.OrganisationIdentifier, t.UoPCode }, name: "IX_HeldReportedActualGroup_FundingStreamPeriodCodeOrganisationIdentifierUoPCode");
            
        }
        
        public override void Down()
        {
            DropIndex("MonitoringDeliverables.HeldReportedActualGroup", "IX_HeldReportedActualGroup_FundingStreamPeriodCodeOrganisationIdentifierUoPCode");
            DropTable("MonitoringDeliverables.HeldReportedActualGroup");
        }
    }
}
