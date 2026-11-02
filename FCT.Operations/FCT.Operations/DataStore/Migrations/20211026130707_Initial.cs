using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FCT.Operations.DataStore.Migrations
{
    public partial class Initial : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "Operations");

            migrationBuilder.CreateTable(
                name: "AuditMessage",
                schema: "Operations",
                columns: table => new
                {
                    MessageId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ProcessingEndpoint = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    MessageType = table.Column<string>(type: "nvarchar(120)", maxLength: 120, nullable: false),
                    SentTime = table.Column<DateTime>(type: "datetime", nullable: false),
                    OriginatingEndpoint = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    BusinessKey = table.Column<string>(type: "nvarchar(80)", maxLength: 80, nullable: false),
                    MessageBytes = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    PropertiesBytes = table.Column<byte[]>(type: "varbinary(max)", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getutcdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.AuditMessage", x => new { x.MessageId, x.ProcessingEndpoint });
                });

            migrationBuilder.CreateTable(
                name: "DataFixHistory",
                schema: "Operations",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Release = table.Column<string>(type: "nvarchar(10)", maxLength: 10, nullable: false),
                    StoryNumber = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.DataFixHistory", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "DeployedConfigVersion",
                schema: "Operations",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Version = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    Checksum = table.Column<byte[]>(type: "varbinary(16)", maxLength: 16, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.DeployedConfigVersion", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "DuplicateContract",
                schema: "Operations",
                columns: table => new
                {
                    ContractNumber = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    Version = table.Column<int>(type: "int", nullable: false),
                    SubVersion = table.Column<int>(type: "int", nullable: false),
                    NumDuplicateAllocations = table.Column<int>(type: "int", nullable: false, defaultValue: 0),
                    NumDuplicateContracts = table.Column<int>(type: "int", nullable: false, defaultValue: 0),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.DuplicateContract", x => new { x.ContractNumber, x.Version, x.SubVersion });
                });

            migrationBuilder.CreateTable(
                name: "IntegrityCheckChangeTracking",
                schema: "Operations",
                columns: table => new
                {
                    Name = table.Column<string>(type: "nvarchar(70)", maxLength: 70, nullable: false),
                    CurrentVersion = table.Column<long>(type: "bigint", nullable: true),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.IntegrityCheckChangeTracking", x => x.Name);
                });

            migrationBuilder.CreateTable(
                name: "ProcessedMessage",
                schema: "Operations",
                columns: table => new
                {
                    MessageId = table.Column<string>(type: "nvarchar(36)", maxLength: 36, nullable: false),
                    ProcessingEndpoint = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.ProcessedMessage", x => new { x.MessageId, x.ProcessingEndpoint });
                });

            migrationBuilder.CreateTable(
                name: "Session",
                schema: "Operations",
                columns: table => new
                {
                    Identifier = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getutcdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.Session", x => x.Identifier);
                });

            migrationBuilder.CreateIndex(
                name: "IX_AUDITMESSAGE_CREATED_DATE",
                schema: "Operations",
                table: "AuditMessage",
                column: "CreatedDate")
                .Annotation("SqlServer:Clustered", false);

            migrationBuilder.CreateIndex(
                name: "IX_AuditMessage_MessageType",
                schema: "Operations",
                table: "AuditMessage",
                column: "MessageType");

            migrationBuilder.CreateIndex(
                name: "IX_DataFixHistory_ReleaseStoryNumberName",
                schema: "Operations",
                table: "DataFixHistory",
                columns: new[] { "Release", "StoryNumber", "Name" },
                unique: true);

            migrationBuilder.CreateTable(
                name: "FundingReportFSP",
                schema: "Operations",
                columns: table => new
                {
                    FspCode = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FundingPeriod = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Order = table.Column<int>(type: "int", nullable: false),
                    Description = table.Column<string>(type: "nvarchar(150)", maxLength: 150, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getutcdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.FundingReportFSP", x => new { x.FspCode, x.FundingPeriod });
                });

            migrationBuilder.CreateTable(
                name: "FundingReportProvider",
                schema: "Operations",
                columns: table => new
                {
                    Ukprn = table.Column<int>(type: "int", nullable: false),
                    FundingPeriod = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Type = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    Period = table.Column<int>(type: "int", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getutcdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.FundingReportProvider", x => new { x.Ukprn, x.FundingPeriod });
                });

            migrationBuilder.CreateTable(
                name: "FundingStreamPeriod",
                schema: "Operations",
                columns: table => new
                {
                    FundingStreamPeriodCode = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    PeriodTypeCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getutcdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.FundingStreamPeriod", x => x.FundingStreamPeriodCode);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AuditMessage",
                schema: "Operations");

            migrationBuilder.DropTable(
                name: "DataFixHistory",
                schema: "Operations");

            migrationBuilder.DropTable(
                name: "DeployedConfigVersion",
                schema: "Operations");

            migrationBuilder.DropTable(
                name: "DuplicateContract",
                schema: "Operations");

            migrationBuilder.DropTable(
                name: "IntegrityCheckChangeTracking",
                schema: "Operations");

            migrationBuilder.DropTable(
                name: "ProcessedMessage",
                schema: "Operations");

            migrationBuilder.DropTable(
                name: "Session",
                schema: "Operations");
        }
    }
}
