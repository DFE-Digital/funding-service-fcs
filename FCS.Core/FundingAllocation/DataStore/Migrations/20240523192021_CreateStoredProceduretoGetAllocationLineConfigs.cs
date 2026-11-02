using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateStoredProceduretoGetAllocationLineConfigs : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
					const string createProcedureSql = @"
                    CREATE PROCEDURE FundingAllocation.GetAllocationLineConfigs
	                    @allocationFundingStreamCode nvarchar(50),
                        @allocationPeriodId nvarchar(50),
                        @fundingLineCode nvarchar(50)
                    AS
                    BEGIN
	                    SELECT alc.FspCode,
                          alc.DeliverableCode,
                          alc.ProviderCategory,
                          d.DeliverableName,
                          d.DisplayOrder,
                          fsp.FundingStreamCode,
                          fsp.AllocationReferencePrefix
                   FROM [FundingAllocation].[AllocationLineConfig] alc,
                        [FundingAllocation].[FspDeliverableConfig] d,   
                        [FundingAllocation].[FundingStreamPeriodConfig] fsp
                   WHERE alc.fspCode = d.fspcode
                   and alc.deliverableCode = d.deliverableCode
                   and d.FspCode = fsp.FundingStreamPeriodCode
                   and alc.[FundingStreamCode] = @allocationFundingStreamCode
                   AND alc.[PeriodId] = @allocationPeriodId
                   AND alc.[FundingLineCode] = @fundingLineCode
END
                    ";

			migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.GetAllocationLineConfigs");
			migrationBuilder.Sql($"EXEC('{createProcedureSql}')");
		}

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            const string createProcedureSql = @"
                    CREATE PROCEDURE FundingAllocation.GetAllocationLineConfigs
	                    @allocationFundingStreamCode nvarchar(50),
                        @allocationPeriodId nvarchar(50),
                        @fundingLineCode nvarchar(50)
                    AS
                    BEGIN
	                    SELECT alc.FspCode,
                          alc.DeliverableCode,
                          alc.ProviderCategory,
                          d.DeliverableName,
                          d.DisplayOrder,
                          fsp.FundingStreamCode,
                          fsp.AllocationReferencePrefix
                   FROM [FundingAllocation].[AllocationLineConfig] alc,
                        [FundingAllocation].[FspDeliverableConfig] d,   
                        [FundingAllocation].[FundingStreamPeriodConfig] fsp
                   WHERE alc.fspCode = d.fspcode
                   and alc.deliverableCode = d.deliverableCode
                   and d.FspCode = fsp.FundingStreamPeriodCode
                   and alc.[FundingStreamCode] = @allocationFundingStreamCode
                   AND alc.[PeriodId] = @allocationPeriodId
                   AND alc.[FundingLineCode] = @fundingLineCode
END
                    ";

            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.GetAllocationLineConfigs");
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");

        }
    }
}
