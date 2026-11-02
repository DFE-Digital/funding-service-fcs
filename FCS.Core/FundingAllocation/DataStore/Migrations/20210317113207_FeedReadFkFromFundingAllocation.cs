using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class FeedReadFkFromFundingAllocation : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ReadId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_FundingAllocation_ReadId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "ReadId");

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocation_FeedRead_ReadId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "ReadId",
                principalSchema: "FundingAllocation",
                principalTable: "FeedRead",
                principalColumn: "ReadId",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocation_FeedRead_ReadId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropIndex(
                name: "IX_FundingAllocation_ReadId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "ReadId",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
