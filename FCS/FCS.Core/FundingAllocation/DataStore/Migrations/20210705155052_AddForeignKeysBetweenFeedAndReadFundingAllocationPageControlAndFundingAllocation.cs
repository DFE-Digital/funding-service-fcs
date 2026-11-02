using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddForeignKeysBetweenFeedAndReadFundingAllocationPageControlAndFundingAllocation : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_FundingAllocation_ReadId_PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                columns: new[] { "ReadId", "PageNumber" });

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocation_FundingAllocationPageControl_ReadId_PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                columns: new[] { "ReadId", "PageNumber" },
                principalSchema: "FundingAllocation",
                principalTable: "FundingAllocationPageControl",
                principalColumns: new[] { "ReadId", "PageNumber" },
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocationPageControl_FeedRead_ReadId",
                schema: "FundingAllocation",
                table: "FundingAllocationPageControl",
                column: "ReadId",
                principalSchema: "FundingAllocation",
                principalTable: "FeedRead",
                principalColumn: "ReadId",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocation_FundingAllocationPageControl_ReadId_PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocationPageControl_FeedRead_ReadId",
                schema: "FundingAllocation",
                table: "FundingAllocationPageControl");

            migrationBuilder.DropIndex(
                name: "IX_FundingAllocation_ReadId_PageNumber",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
