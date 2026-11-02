using Microsoft.EntityFrameworkCore.Migrations;
using System;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateContractTableLinkToFundingAllocationTableAndAddMissingCreatedDates : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Contract",
                schema: "FundingAllocation",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ContractNumber = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ContractVersionNumber = table.Column<int>(type: "int", nullable: false),
                    ContractSubVersionNumber = table.Column<int>(type: "int", nullable: false),
                    IsCreatedInCrm = table.Column<bool>(type: "bit", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Contract", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_FundingAllocation_ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "ContractId");

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocation_Contract_ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "ContractId",
                principalSchema: "FundingAllocation",
                principalTable: "Contract",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedDate",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation",
                type: "datetime2",
                nullable: false,
                defaultValueSql: "GETUTCDATE()");

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedDate",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod",
                type: "datetime2",
                nullable: false,
                defaultValueSql: "GETUTCDATE()");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocation_Contract_ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropTable(
                name: "Contract",
                schema: "FundingAllocation");

            migrationBuilder.DropIndex(
                name: "IX_FundingAllocation_ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "CreatedBy",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod");

            migrationBuilder.DropColumn(
                name: "CreatedBy",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation");
        }
    }
}
