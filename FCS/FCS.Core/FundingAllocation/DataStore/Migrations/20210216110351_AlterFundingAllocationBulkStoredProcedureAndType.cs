namespace FundingAllocation.DataStore.Migrations
{
    using Microsoft.EntityFrameworkCore.Migrations;

    public partial class AlterFundingAllocationBulkStoredProcedureAndType : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.InsertFundingAllocations");
            migrationBuilder.Sql("DROP TYPE FundingAllocation.FundingAllocationTableType");

            const string createTypeSql = @"
CREATE TYPE FundingAllocation.FundingAllocationTableType AS TABLE (
	FundingId nvarchar(200),
	FundingVersion nvarchar(50),
	Period nvarchar(50),
	AllocationFundingStream nvarchar(50),
	UKPRN nvarchar(50),
	Value decimal(18,2),
	PositionInPage int,
	PageNumber int,
	ProviderFundingCount int)
";
            const string createProcedureSql = @"
CREATE PROCEDURE FundingAllocation.InsertFundingAllocations
	@fundingAllocationsTable FundingAllocation.FundingAllocationTableType READONLY
AS
BEGIN
	INSERT INTO FundingAllocation.FundingAllocation (
		FundingId,
		FundingVersion,
		Period,
		AllocationFundingStream,
		UKPRN,
		Value,
		PositionInPage,
		PageNumber,
		ProviderFundingCount)
	SELECT
		FundingId,
		FundingVersion,
		Period,
		AllocationFundingStream,
		UKPRN,
		Value,
		PositionInPage,
		PageNumber,
		ProviderFundingCount
	FROM
		@fundingAllocationsTable
END
";
            migrationBuilder.Sql(createTypeSql);
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
        }
    }
}
