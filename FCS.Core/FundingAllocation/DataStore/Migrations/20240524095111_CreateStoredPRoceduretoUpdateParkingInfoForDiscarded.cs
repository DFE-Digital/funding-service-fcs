using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateStoredPRoceduretoUpdateParkingInfoForDiscarded : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            const string createTypeSql = @"
                    CREATE TYPE FundingAllocationNamesUDT AS TABLE (
	                    FundingAllocationName nvarchar(200))
                    ";

            const string createProcedureSql = @"
                    CREATE PROCEDURE FundingAllocation.UpdateParkingInfoForDiscarded	                    
                        @discardedStatus nvarchar(50),
                        @now DATETIME,
                        @fundingAllocationNames FundingAllocationNamesUDT READONLY,
                        @readIdToIgnore int
                        
                    AS
                    BEGIN
	                    UPDATE pi
                                  SET LastDiscarded = @now
                                  FROM [FundingAllocation].ParkingAndDiscardedInfo AS pi
                                  WHERE EXISTS
                                  (
                                    select 1 from [FundingAllocation].[FundingAllocation]
                                    where FundingAllocationName in (Select FundingAllocationName from @fundingAllocationNames)
                                    and Status = @discardedStatus
                                    and ReadId <> @readIdToIgnore
	                                and FundingId = pi.FundingAllocationId
                                  )
                                  AND pi.LastDiscarded is null
                    END
                    ";
            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.UpdateParkingInfoForDiscarded");
            migrationBuilder.Sql("DROP TYPE FundingAllocationNamesUDT");
            migrationBuilder.Sql(createTypeSql);
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");

        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            const string createTypeSql = @"
                    CREATE TYPE FundingAllocationNamesUDT AS TABLE (
	                    FundingAllocationName nvarchar(200))
                    ";

            const string createProcedureSql = @"
                    CREATE PROCEDURE FundingAllocation.UpdateParkingInfoForDiscarded	                    
                        @discardedStatus nvarchar(50),
                        @now DATETIME,
                        @fundingAllocationNames FundingAllocationNamesUDT READONLY,
                        @readIdToIgnore int,
                        
                    AS
                    BEGIN
	                    UPDATE pi
                                  SET LastDiscarded = @now
                                  FROM [FundingAllocation].ParkingAndDiscardedInfo AS pi
                                  WHERE EXISTS
                                  (
                                    select 1 from [FundingAllocation].[FundingAllocation]
                                    where FundingAllocationName in (Select FundingAllocationName from @fundingAllocationNames)
                                    and Status = @discardedStatus
                                    and ReadId <> @readIdToIgnore
	                                and FundingId = pi.FundingAllocationId
                                  )
                                  AND pi.LastDiscarded is null
                    END
                    ";
            migrationBuilder.Sql("DROP PROCEDURE FundingAllocation.UpdateParkingInfoForDiscarded");
            migrationBuilder.Sql("DROP TYPE FundingAllocationNamesUDT");
            migrationBuilder.Sql(createTypeSql);
            migrationBuilder.Sql($"EXEC('{createProcedureSql}')");

        }
    }
}
