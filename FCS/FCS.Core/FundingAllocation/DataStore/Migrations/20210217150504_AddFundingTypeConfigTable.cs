using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddFundingTypeConfigTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "FundingTypeConfig",
                schema: "FundingAllocation",
                columns: table => new
                {
                    FundingTypeCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ContractReferencePrefix = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FundingTypeConfig", x => x.FundingTypeCode);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FundingTypeConfig",
                schema: "FundingAllocation");
        }
    }
}
