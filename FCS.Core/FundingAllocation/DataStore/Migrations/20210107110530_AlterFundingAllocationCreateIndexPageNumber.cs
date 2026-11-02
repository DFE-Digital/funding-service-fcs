using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterFundingAllocationCreateIndexPageNumber : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_FundingAllocation_PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "PageNumber");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_FundingAllocation_PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
