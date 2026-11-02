using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class FundingAllocationTableRenamePageIndexToPositionInPage : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "PageIndex",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                newName: "PositionInPage");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "PositionInPage",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                newName: "PageIndex");
        }
    }
}
