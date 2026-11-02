using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddStatusSubstatusIndexToFundingAllocation : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_FundingAllocation_Status_SubStatus",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                columns: new[] { "Status", "SubStatus" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_FundingAllocation_Status_SubStatus",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
