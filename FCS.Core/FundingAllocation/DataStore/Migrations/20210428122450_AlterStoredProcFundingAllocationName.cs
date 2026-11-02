using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterStoredProcFundingAllocationName : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
	                ProviderFundingCount int,
                    ReadId int,
                    FundingAllocationName nvarchar(200))
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
		            ProviderFundingCount,
                    ReadId,
                    FundingAllocationName)
	            SELECT
		            FundingId,
		            FundingVersion,
		            Period,
		            AllocationFundingStream,
		            UKPRN,
		            Value,
		            PositionInPage,
		            PageNumber,
		            ProviderFundingCount,
                    ReadId,
                    FundingAllocationName
	            FROM
		                    @fundingAllocationsTable
                    END
                    ";
            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.InsertFundingAllocations");
            migrationBuilder.Sql("DROP TYPE FundingAllocation.FundingAllocationTableType");
            migrationBuilder.Sql(createTypeSql);
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");
		}

        protected override void Down(MigrationBuilder migrationBuilder)
        {
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
	                    ProviderFundingCount int,
                        ReadId int)
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
		            ProviderFundingCount,
                    ReadId)
	            SELECT
		            FundingId,
		            FundingVersion,
		            Period,
		            AllocationFundingStream,
		            UKPRN,
		            Value,
		            PositionInPage,
		            PageNumber,
		            ProviderFundingCount,
                    ReadId
	            FROM
		                    @fundingAllocationsTable
                    END
                    ";
            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.InsertFundingAllocations");
            migrationBuilder.Sql("DROP TYPE FundingAllocation.FundingAllocationTableType");
            migrationBuilder.Sql(createTypeSql);
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");
		}
    }
}
