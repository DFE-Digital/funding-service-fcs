using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddedProviderCategoryExceptionPrimaryKey : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddPrimaryKey(
                name: "PK_ProviderCategoryException",
                schema: "FundingAllocation",
                table: "ProviderCategoryException",
                columns: new[] { "FundingTypeCode", "FundingPeriodCode", "UKPRN" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_ProviderCategoryException",
                schema: "FundingAllocation",
                table: "ProviderCategoryException");
        }
    }
}
