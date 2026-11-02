using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterFundingAllocationPageControlDropPageNumberIndex : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropUniqueConstraint(
                name: "AK_FundingAllocationPageControl_PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocationPageControl");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddUniqueConstraint(
                name: "AK_FundingAllocationPageControl_PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocationPageControl",
                column: "PageNumber");
        }
    }
}
