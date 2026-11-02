using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterFundingAllocationAddPageColumns : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "PageIndex",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "PageIndex",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
