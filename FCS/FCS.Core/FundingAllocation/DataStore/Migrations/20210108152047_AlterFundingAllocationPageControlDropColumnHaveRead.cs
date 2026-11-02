using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterFundingAllocationPageControlDropColumnHaveRead : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "HaveRead",
                schema: "FundingAllocation",
                table: "FundingAllocationPageControl");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "HaveRead",
                schema: "FundingAllocation",
                table: "FundingAllocationPageControl",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }
    }
}
