using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddRelationshipToFundingAllocationColToContract : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Contract_ContractNumber_ContractVersionNumber_ContractSubVersionNumber",
                schema: "FundingAllocation",
                table: "Contract");

            migrationBuilder.AddColumn<string>(
                name: "RelationshipToFundingAllocation",
                schema: "FundingAllocation",
                table: "Contract",
                type: "nvarchar(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "Created");

            migrationBuilder.CreateIndex(
                name: "IX_Contract_ContractNumber_ContractVersionNumber_ContractSubVersionNumber_RelationshipToFundingAllocation",
                schema: "FundingAllocation",
                table: "Contract",
                columns: new[] { "ContractNumber", "ContractVersionNumber", "ContractSubVersionNumber", "RelationshipToFundingAllocation" },
                unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Contract_ContractNumber_ContractVersionNumber_ContractSubVersionNumber_RelationshipToFundingAllocation",
                schema: "FundingAllocation",
                table: "Contract");

            migrationBuilder.DropColumn(
                name: "RelationshipToFundingAllocation",
                schema: "FundingAllocation",
                table: "Contract");

            migrationBuilder.CreateIndex(
                name: "IX_Contract_ContractNumber_ContractVersionNumber_ContractSubVersionNumber",
                schema: "FundingAllocation",
                table: "Contract",
                columns: new[] { "ContractNumber", "ContractVersionNumber", "ContractSubVersionNumber" },
                unique: true);
        }
    }
}
