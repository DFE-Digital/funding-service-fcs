namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "MonitoringDeliverables.AllocationDeliverablePeriod",
                c => new
                    {
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
                    })
                .PrimaryKey(t => new { t.OrganisationId, t.FundingStreamPeriodCode, t.UopCode, t.DeliverableCode, t.Period });
            
            CreateTable(
                "MonitoringDeliverables.FundingStreamPeriodDeliverable",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 100),
                        DeliverableCode = c.Int(nullable: false),
                        ParentDeliverableCode = c.Int(nullable: false),
                        DeliverableName = c.String(nullable: false, maxLength: 100),
                        AllowProfile = c.Boolean(nullable: false),
                        AllowActuals = c.Boolean(nullable: false),
                        AllowPayment = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => new { t.FundingStreamPeriodCode, t.DeliverableCode });

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
            DropTable("MonitoringDeliverables.FundingStreamPeriodDeliverable");
            DropTable("MonitoringDeliverables.AllocationDeliverablePeriod");
            DropStoredProcedure("MonitoringDeliverables.DeleteAllDeliverablePeriodsForAllocation");
        }
    }
}
