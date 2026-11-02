using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddAllAmendmentsRequireSigningColToFundingTypeFundingPeriodConfig : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "AllAmendmentsRequireSigning",
                schema: "FundingAllocation",
                table: "FundingTypeFundingPeriodConfig",
                type: "bit",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AllAmendmentsRequireSigning",
                schema: "FundingAllocation",
                table: "FundingTypeFundingPeriodConfig");
        }
    }
}
