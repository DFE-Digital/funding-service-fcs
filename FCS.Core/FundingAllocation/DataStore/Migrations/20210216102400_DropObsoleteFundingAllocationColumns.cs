using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class DropObsoleteFundingAllocationColumns : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ContractType",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "FSPGroup",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "FundingType",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ContractType",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "FSPGroup",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "FundingType",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: false,
                defaultValue: "");
        }
    }
}
