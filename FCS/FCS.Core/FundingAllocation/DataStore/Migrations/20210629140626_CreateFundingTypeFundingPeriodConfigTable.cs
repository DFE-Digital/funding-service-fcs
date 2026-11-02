using Microsoft.EntityFrameworkCore.Migrations;
using System;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateFundingTypeFundingPeriodConfigTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "FundingTypeFundingPeriodConfig",
                schema: "FundingAllocation",
                columns: table => new
                {
                    FundingTypeCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FundingPeriodName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FtpGroupCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    PrecedingFtpFundingType = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    PrecedingFtpFundingPeriod = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    IncludeAllContractsOnSummaryOfFunding = table.Column<bool>(type: "bit", nullable: false),
                    AllowNewAmendment = table.Column<bool>(type: "bit", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FundingTypeFundingPeriodConfig", x => new { x.FundingTypeCode, x.FundingPeriodName });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FundingTypeFundingPeriodConfig",
                schema: "FundingAllocation");
        }
    }
}
