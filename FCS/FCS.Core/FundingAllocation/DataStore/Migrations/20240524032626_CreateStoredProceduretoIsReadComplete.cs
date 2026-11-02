using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateStoredProceduretoIsReadComplete : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            const string createProcedureSql = @"
                    CREATE PROCEDURE FundingAllocation.IsReadComplete
	                    @fundingId nvarchar(200)
                    AS
                    BEGIN
	                    SELECT
                                      funding.ReadId,

                                      (SELECT COUNT(1)
                                      FROM [FundingAllocation].[FundingAllocationPageControl] pc
                                      WHERE pc.LatestBookmarkOnPage IS NULL
                                      AND pc.ReadId = funding.ReadId)  AS pagesYetToRead,

                                      (SELECT COUNT(1)
                                      FROM (SELECT fa.ProviderFundingCount AS expectedNumProviders,
                                            (SELECT COUNT(1)
                                            FROM [FundingAllocation].[ProviderFundingAllocation] pfa
                                            WHERE pfa.FundingId = fa.FundingId)	AS actualNumProviders
                                            FROM [FundingAllocation].[FundingAllocation] fa
                                            WHERE fa.ReadId = funding.ReadId) t
                                      WHERE t.expectedNumProviders != t.actualNumProviders)  AS totalFAsWithMissingProviders

                                FROM [FundingAllocation].[FundingAllocation] funding
                                WHERE funding.FundingId = @fundingId
END
                    ";

            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.IsReadComplete");
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");

        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            const string createProcedureSql = @"
                     CREATE PROCEDURE FundingAllocation.IsReadComplete
	                    @fundingId nvarchar(200)
                    AS
                    BEGIN
	                    SELECT
                                      funding.ReadId,

                                      (SELECT COUNT(1)
                                      FROM [FundingAllocation].[FundingAllocationPageControl] pc
                                      WHERE pc.LatestBookmarkOnPage IS NULL
                                      AND pc.ReadId = funding.ReadId)  AS pagesYetToRead,

                                      (SELECT COUNT(1)
                                      FROM (SELECT fa.ProviderFundingCount AS expectedNumProviders,
                                            (SELECT COUNT(1)
                                            FROM [FundingAllocation].[ProviderFundingAllocation] pfa
                                            WHERE pfa.FundingId = fa.FundingId)	AS actualNumProviders
                                            FROM [FundingAllocation].[FundingAllocation] fa
                                            WHERE fa.ReadId = funding.ReadId) t
                                      WHERE t.expectedNumProviders != t.actualNumProviders)  AS totalFAsWithMissingProviders

                                FROM [FundingAllocation].[FundingAllocation] funding
                                WHERE funding.FundingId = @fundingId
END
                    ";


            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.IsReadComplete");
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");

        }
    }
}
