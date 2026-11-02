using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CorrectFundingAllocationProfilePeriodPrimaryKey : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_FundingAllocationProfilePeriod",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod");

            migrationBuilder.DropIndex(
                name: "IX_FundingAllocationProfilePeriod_ProviderFundingId_FundingLineCode",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod");

            migrationBuilder.AddPrimaryKey(
                name: "PK_FundingAllocationProfilePeriod",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod",
                columns: new[] { "ProviderFundingId", "FundingLineCode", "Period" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_FundingAllocationProfilePeriod",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod");

            migrationBuilder.AddPrimaryKey(
                name: "PK_FundingAllocationProfilePeriod",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod",
                columns: new[] { "ProviderFundingId", "Period" });

            migrationBuilder.CreateIndex(
                name: "IX_FundingAllocationProfilePeriod_ProviderFundingId_FundingLineCode",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod",
                columns: new[] { "ProviderFundingId", "FundingLineCode" });
        }
    }
}
