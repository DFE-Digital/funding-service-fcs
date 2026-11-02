using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddedFkeyFromFundingAllocationsToStatusSubStatusConfig : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocation_StatusSubStatusConfig_Status_SubStatus",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                columns: new[] { "Status", "SubStatus" },
                principalSchema: "FundingAllocation",
                principalTable: "StatusSubStatusConfig",
                principalColumns: new[] { "Status", "SubStatus" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocation_StatusSubStatusConfig_Status_SubStatus",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }
    }
}
