namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateAllocationDeliverableTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.AllocationDeliverabePeriod",
                c => new
                    {
                        OrganisationId = c.String(nullable: false, maxLength: 10),
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                        UopCode = c.String(nullable: false, maxLength: 100),
                        DeliverableCode = c.Int(nullable: false),
                        Period = c.String(nullable: false, maxLength: 6),
                    })
                .PrimaryKey(t => new { t.OrganisationId, t.FundingStreamPeriodCode, t.UopCode, t.DeliverableCode, t.Period });

            CreateStoredProcedure(
                "MonitoringDeliverables.DeleteAllDeliverablePeriodsForAllocation",
                p => new
                {
                    organisationId = p.String(maxLength: 10),
                    fundingStreamPeriodCode = p.String(maxLength: 100),
                    uopCode = p.String(maxLength: 100)
                },
                body:
                    @"  DELETE 
                            FROM AllocationDeliverablePeriod 
	                    WHERE 
		                    OrganisationId = @organisationId
		                    AND FundingStreamPeriodCode = @fundingStreamPeriodCode 
		                    AND UopCode = uopCode

	                    SELECT @@ROWCOUNT"
                );

        }
        
        public override void Down()
        {
            DropTable("MonitoringDeliverables.AllocationDeliverabePeriod");
            DropStoredProcedure("MonitoringDeliverables.DeleteAllDeliverablePeriodsForAllocation");
        }
    }
}
