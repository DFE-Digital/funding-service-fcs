using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class ContractTableAddUniqueIndex : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_Contract_ContractNumber_ContractVersionNumber_ContractSubVersionNumber",
                schema: "FundingAllocation",
                table: "Contract",
                columns: new[] { "ContractNumber", "ContractVersionNumber", "ContractSubVersionNumber" },
                unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Contract_ContractNumber_ContractVersionNumber_ContractSubVersionNumber",
                schema: "FundingAllocation",
                table: "Contract");
        }
    }
}
