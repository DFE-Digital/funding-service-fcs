using Microsoft.EntityFrameworkCore.Migrations;
using System;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class RenameTableFspDeliverableToFspDeliverableConfig : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AllocationLineConfig_FspDeliverable_FspCode_DeliverableCode",
                schema: "FundingAllocation",
                table: "AllocationLineConfig");

            migrationBuilder.DropTable(
                name: "FspDeliverable",
                schema: "FundingAllocation");

            migrationBuilder.CreateTable(
                name: "FspDeliverableConfig",
                schema: "FundingAllocation",
                columns: table => new
                {
                    FspCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    DeliverableCode = table.Column<int>(type: "int", nullable: false),
                    DeliverableName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FspDeliverableConfig", x => new { x.FspCode, x.DeliverableCode });
                });

            migrationBuilder.AddForeignKey(
                name: "FK_AllocationLineConfig_FspDeliverableConfig_FspCode_DeliverableCode",
                schema: "FundingAllocation",
                table: "AllocationLineConfig",
                columns: new[] { "FspCode", "DeliverableCode" },
                principalSchema: "FundingAllocation",
                principalTable: "FspDeliverableConfig",
                principalColumns: new[] { "FspCode", "DeliverableCode" },
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AllocationLineConfig_FspDeliverableConfig_FspCode_DeliverableCode",
                schema: "FundingAllocation",
                table: "AllocationLineConfig");

            migrationBuilder.DropTable(
                name: "FspDeliverableConfig",
                schema: "FundingAllocation");

            migrationBuilder.CreateTable(
                name: "FspDeliverable",
                schema: "FundingAllocation",
                columns: table => new
                {
                    FspCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    DeliverableCode = table.Column<int>(type: "int", nullable: false),
                    DeliverableName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FspDeliverable", x => new { x.FspCode, x.DeliverableCode });
                });

            migrationBuilder.AddForeignKey(
                name: "FK_AllocationLineConfig_FspDeliverable_FspCode_DeliverableCode",
                schema: "FundingAllocation",
                table: "AllocationLineConfig",
                columns: new[] { "FspCode", "DeliverableCode" },
                principalSchema: "FundingAllocation",
                principalTable: "FspDeliverable",
                principalColumns: new[] { "FspCode", "DeliverableCode" },
                onDelete: ReferentialAction.Cascade);
        }
    }
}
