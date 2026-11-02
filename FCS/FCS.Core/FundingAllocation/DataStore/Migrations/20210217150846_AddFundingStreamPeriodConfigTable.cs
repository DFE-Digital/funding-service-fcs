using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddFundingStreamPeriodConfigTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "FundingStreamPeriodConfig",
                schema: "FundingAllocation",
                columns: table => new
                {
                    FundingStreamPeriodCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FundingStreamCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    AllocationReferencePrefix = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FundingStreamPeriodConfig", x => x.FundingStreamPeriodCode);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FundingStreamPeriodConfig",
                schema: "FundingAllocation");
        }
    }
}
