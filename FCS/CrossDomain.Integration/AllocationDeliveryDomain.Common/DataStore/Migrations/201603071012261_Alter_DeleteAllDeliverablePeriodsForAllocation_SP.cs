namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;

    public partial class Alter_DeleteAllDeliverablePeriodsForAllocation_SP : DbMigration
    {
        public override void Up()
        {
            AlterStoredProcedure("MonitoringDeliverables.DeleteAllDeliverablePeriodsForAllocation",
               p => new
               {
                   allocationNumber = p.String(maxLength: 20)
               },
               body:
                   @"  DELETE 
                                FROM AllocationDeliverablePeriod 
	                        WHERE 
		                        ContractAllocationNumber = @allocationNumber

	                        SELECT @@ROWCOUNT"
               );
        }

        public override void Down()
        {
            AlterStoredProcedure("MonitoringDeliverables.DeleteAllDeliverablePeriodsForAllocation",
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
    }
}
