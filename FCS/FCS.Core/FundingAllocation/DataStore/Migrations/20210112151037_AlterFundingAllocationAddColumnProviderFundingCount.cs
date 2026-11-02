using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterFundingAllocationAddColumnProviderFundingCount : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ProviderFundingCount",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ProviderFundingCount",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
