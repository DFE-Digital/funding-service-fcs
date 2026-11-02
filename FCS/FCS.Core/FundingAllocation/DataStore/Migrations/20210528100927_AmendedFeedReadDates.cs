using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AmendedFeedReadDates : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "ReadCompletedDate",
                schema: "FundingAllocation",
                table: "FeedRead",
                newName: "CfsReadCompletedDate");

            migrationBuilder.AddColumn<DateTime>(
                name: "JobCompletedDate",
                schema: "FundingAllocation",
                table: "FeedRead",
                type: "datetime",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "JobCompletedDate",
                schema: "FundingAllocation",
                table: "FeedRead");

            migrationBuilder.RenameColumn(
                name: "CfsReadCompletedDate",
                schema: "FundingAllocation",
                table: "FeedRead",
                newName: "ReadCompletedDate");
        }
    }
}
