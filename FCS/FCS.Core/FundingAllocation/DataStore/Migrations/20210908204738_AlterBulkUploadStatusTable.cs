using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterBulkUploadStatusTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                 name: "BulkUploadStatus",
                 schema: "FundingAllocation");

            migrationBuilder.CreateTable(
                name: "BulkUploadStatus",
                schema: "FundingAllocation",
                columns: table => new
                {
                    BulkUploadBatchId = table.Column<Guid>(type: "UniqueIdentifier", nullable: false),
                    FundingTypeCode = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FundingPeriodName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Status = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BulkUploadStatus", x => x.BulkUploadBatchId);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BulkUploadStatus_FundingTypeCode_FundingPeriodName",
                schema: "FundingAllocation",
                table: "BulkUploadStatus",
                columns: new[] { "FundingTypeCode", "FundingPeriodName" },
                unique: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                 name: "BulkUploadStatus",
                 schema: "FundingAllocation");

            migrationBuilder.CreateTable(
                name: "BulkUploadStatus",
                schema: "FundingAllocation",
                columns: table => new
                {
                    BulkUploadStatusId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    FundingTypeCode = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FundingPeriodName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Status = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_BulkUploadStatus", x => x.BulkUploadStatusId);
                });

            migrationBuilder.CreateIndex(
                name: "IX_BulkUploadStatus_FundingTypeCode_FundingPeriodName_Status",
                schema: "FundingAllocation",
                table: "BulkUploadStatus",
                columns: new[] { "FundingTypeCode", "FundingPeriodName", "Status" },
                unique: true);
        }
    }
}
