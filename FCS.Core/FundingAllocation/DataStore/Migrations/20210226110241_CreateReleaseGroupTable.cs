using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateReleaseGroupTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocation_Contract_ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.AddColumn<int>(
                name: "ReleaseGroupId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ReleaseGroup",
                schema: "FundingAllocation",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FundingTypeCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FundingPeriodCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FSPGroupCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ContractType = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CrmEntityId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReleaseGroup", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_FundingAllocation_ReleaseGroupId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "ReleaseGroupId");

            migrationBuilder.CreateIndex(
                name: "IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_CrmEntityId",
                schema: "FundingAllocation",
                table: "ReleaseGroup",
                columns: new[] { "FundingTypeCode", "FundingPeriodCode", "FSPGroupCode", "ContractType", "CrmEntityId" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocation_Contract_ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "ContractId",
                principalSchema: "FundingAllocation",
                principalTable: "Contract",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocation_ReleaseGroup_ReleaseGroupId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "ReleaseGroupId",
                principalSchema: "FundingAllocation",
                principalTable: "ReleaseGroup",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocation_Contract_ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropForeignKey(
                name: "FK_FundingAllocation_ReleaseGroup_ReleaseGroupId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropTable(
                name: "ReleaseGroup",
                schema: "FundingAllocation");

            migrationBuilder.DropIndex(
                name: "IX_FundingAllocation_ReleaseGroupId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "ReleaseGroupId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.AddForeignKey(
                name: "FK_FundingAllocation_Contract_ContractId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "ContractId",
                principalSchema: "FundingAllocation",
                principalTable: "Contract",
                principalColumn: "Id",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
