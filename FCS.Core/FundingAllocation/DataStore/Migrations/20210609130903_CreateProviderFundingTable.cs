using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    using System;

    public partial class CreateProviderFundingTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocationLine_ProviderFundingAllocation_ProviderFundingId",
                schema: "FundingAllocation",
                table: "FundingAllocationLine");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ProviderFundingAllocation",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation");

            migrationBuilder.DropColumn(
                name: "DeliveryUkprn",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation");

            migrationBuilder.DropColumn(
                name: "ProviderSubType",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation");

            migrationBuilder.DropColumn(
                name: "ProviderType",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ProviderFundingAllocation",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation",
                columns: new[] { "ProviderFundingId", "FundingId" });

            migrationBuilder.CreateTable(
                name: "ProviderFunding",
                schema: "FundingAllocation",
                columns: table => new
                {
                    ProviderFundingId = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    DeliveryUkprn = table.Column<int>(type: "int", nullable: false),
                    ProviderType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ProviderSubType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProviderFunding", x => x.ProviderFundingId);
                });

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocationLine_ProviderFunding_ProviderFundingId",
                schema: "FundingAllocation",
                table: "FundingAllocationLine",
                column: "ProviderFundingId",
                principalSchema: "FundingAllocation",
                principalTable: "ProviderFunding",
                principalColumn: "ProviderFundingId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_ProviderFundingAllocation_ProviderFunding_ProviderFundingId",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation",
                column: "ProviderFundingId",
                principalSchema: "FundingAllocation",
                principalTable: "ProviderFunding",
                principalColumn: "ProviderFundingId",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocationLine_ProviderFunding_ProviderFundingId",
                schema: "FundingAllocation",
                table: "FundingAllocationLine");

            migrationBuilder.DropForeignKey(
                name: "FK_ProviderFundingAllocation_ProviderFunding_ProviderFundingId",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation");

            migrationBuilder.DropTable(
                name: "ProviderFunding",
                schema: "FundingAllocation");

            migrationBuilder.DropPrimaryKey(
                name: "PK_ProviderFundingAllocation",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation");

            migrationBuilder.AddColumn<int>(
                name: "DeliveryUkprn",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation",
                type: "int",
                nullable: false,
                defaultValue: 0);

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

            migrationBuilder.AddPrimaryKey(
                name: "PK_ProviderFundingAllocation",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation",
                column: "ProviderFundingId");

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocationLine_ProviderFundingAllocation_ProviderFundingId",
                schema: "FundingAllocation",
                table: "FundingAllocationLine",
                column: "ProviderFundingId",
                principalSchema: "FundingAllocation",
                principalTable: "ProviderFundingAllocation",
                principalColumn: "ProviderFundingId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
