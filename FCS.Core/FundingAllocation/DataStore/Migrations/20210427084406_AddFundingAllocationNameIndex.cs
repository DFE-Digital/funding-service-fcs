using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddFundingAllocationNameIndex : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_FundingAllocation_FundingAllocationName",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "FundingAllocationName");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_FundingAllocation_FundingAllocationName",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
