using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateCfsCodesToContractTypeConfigTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "CfsCodesToContractTypeConfig",
                schema: "FundingAllocation",
                columns: table => new
                {
                    FundingTypeCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FundingPeriodCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ProviderCategory = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ContractType = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CfsCodesToContractTypeConfig", x => new { x.FundingTypeCode, x.FundingPeriodCode, x.ProviderCategory });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "CfsCodesToContractTypeConfig",
                schema: "FundingAllocation");
        }
    }
}
