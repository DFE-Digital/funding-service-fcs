using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddStatusColToFundingAllocation : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Status",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Status",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
