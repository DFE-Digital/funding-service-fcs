using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateFundingAllocationBulkStoredProcedureAndType : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            const string createTypeSql = @"
CREATE TYPE FundingAllocation.FundingAllocationTableType AS TABLE (
	FundingId nvarchar(200),
	FundingVersion nvarchar(50),
	FundingType nvarchar(100),
	Period nvarchar(50),
	ContractType nvarchar(200),
	AllocationFundingStream nvarchar(50),
	FSPGroup nvarchar(100),
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
		FundingType,
		Period,
		ContractType,
		AllocationFundingStream,
		FSPGroup,
		UKPRN,
		Value,
		PositionInPage,
		PageNumber,
		ProviderFundingCount)
	SELECT
		FundingId,
		FundingVersion,
		FundingType,
		Period,
		ContractType,
		AllocationFundingStream,
		FSPGroup,
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
            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.InsertFundingAllocations");
            migrationBuilder.Sql("DROP TYPE FundingAllocation.FundingAllocationTableType");
        }
    }
}
