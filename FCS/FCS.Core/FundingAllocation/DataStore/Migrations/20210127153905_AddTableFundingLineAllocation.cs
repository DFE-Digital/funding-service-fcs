using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    using System;

    public partial class AddTableFundingLineAllocation : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocationProfilePeriod_ProviderFundingAllocation_ProviderFundingId",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod");

            migrationBuilder.AddColumn<string>(
                name: "ProviderSubType",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ProviderType",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "FundingLineCode",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "FundingAllocationLine",
                schema: "FundingAllocation",
                columns: table => new
                {
                    ProviderFundingId = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FundingLineCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FundingAllocationLine", x => new { x.ProviderFundingId, x.FundingLineCode });
                    table.ForeignKey(
                        name: "FK_FundingAllocationLine_ProviderFundingAllocation_ProviderFundingId",
                        column: x => x.ProviderFundingId,
                        principalSchema: "FundingAllocation",
                        principalTable: "ProviderFundingAllocation",
                        principalColumn: "ProviderFundingId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_FundingAllocationProfilePeriod_ProviderFundingId_FundingLineCode",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod",
                columns: new[] { "ProviderFundingId", "FundingLineCode" });

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocationProfilePeriod_FundingAllocationLine_ProviderFundingId_FundingLineCode",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod",
                columns: new[] { "ProviderFundingId", "FundingLineCode" },
                principalSchema: "FundingAllocation",
                principalTable: "FundingAllocationLine",
                principalColumns: new[] { "ProviderFundingId", "FundingLineCode" },
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocationProfilePeriod_FundingAllocationLine_ProviderFundingId_FundingLineCode",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod");

            migrationBuilder.DropTable(
                name: "FundingAllocationLine",
                schema: "FundingAllocation");

            migrationBuilder.DropIndex(
                name: "IX_FundingAllocationProfilePeriod_ProviderFundingId_FundingLineCode",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod");

            migrationBuilder.DropColumn(
                name: "ProviderSubType",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation");

            migrationBuilder.DropColumn(
                name: "ProviderType",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation");

            migrationBuilder.DropColumn(
                name: "FundingLineCode",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod");

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocationProfilePeriod_ProviderFundingAllocation_ProviderFundingId",
                schema: "FundingAllocation",
                table: "FundingAllocationProfilePeriod",
                column: "ProviderFundingId",
                principalSchema: "FundingAllocation",
                principalTable: "ProviderFundingAllocation",
                principalColumn: "ProviderFundingId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
