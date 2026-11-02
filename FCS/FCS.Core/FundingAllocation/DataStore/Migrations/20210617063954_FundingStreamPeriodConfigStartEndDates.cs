using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class FundingStreamPeriodConfigStartEndDates : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "StartDate",
                schema: "FundingAllocation",
                table: "FundingStreamPeriodConfig",
                type: "datetime",
                nullable: false,
                defaultValue: new DateTime(2021, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<DateTime>(
                name: "EndDate",
                schema: "FundingAllocation",
                table: "FundingStreamPeriodConfig",
                type: "datetime",
                nullable: false,
                defaultValue: new DateTime(2021, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "EndDate",
                schema: "FundingAllocation",
                table: "FundingStreamPeriodConfig");

            migrationBuilder.DropColumn(
                name: "StartDate",
                schema: "FundingAllocation",
                table: "FundingStreamPeriodConfig");
        }
    }
}
