using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateAllocationFundingStreamConfigTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AllocationFundingStreamConfig",
                schema: "FundingAllocation",
                columns: table => new
                {
                    AllocationFundingStreamCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    AllocationPeriodId = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FundingTypeCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FundingPeriodCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FSPGroupCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AllocationFundingStreamConfig", x => new { x.AllocationFundingStreamCode, x.AllocationPeriodId });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AllocationFundingStreamConfig",
                schema: "FundingAllocation");
        }
    }
}
