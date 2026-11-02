using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class FundingTypeFundingPeriodConfigRenameFundingPeriodNameToFundingPeriod : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "FundingPeriodName",
                schema: "FundingAllocation",
                table: "FundingTypeFundingPeriodConfig",
                newName: "FundingPeriod");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "FundingPeriod",
                schema: "FundingAllocation",
                table: "FundingTypeFundingPeriodConfig",
                newName: "FundingPeriodName");
        }
    }
}
