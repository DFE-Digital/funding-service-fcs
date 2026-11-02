using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddFundingAllocationNameColToFundingAllocation : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("Delete from [FundingAllocation].[FundingAllocation]");
            migrationBuilder.AddColumn<string>(
                name: "FundingAllocationName",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: false,
                defaultValue: "");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FundingAllocationName",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
