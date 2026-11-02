using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateAllocationLineConfigTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AllocationLineConfig",
                schema: "FundingAllocation",
                columns: table => new
                {
                    FundingStreamCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    PeriodId = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FundingLineCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ProviderCategory = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FspCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    DeliverableCode = table.Column<int>(type: "int", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AllocationLineConfig", x => new { x.FundingStreamCode, x.PeriodId, x.FundingLineCode, x.ProviderCategory });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AllocationLineConfig",
                schema: "FundingAllocation");
        }
    }
}
