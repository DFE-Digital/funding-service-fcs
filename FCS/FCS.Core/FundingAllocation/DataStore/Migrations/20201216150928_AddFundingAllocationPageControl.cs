using Microsoft.EntityFrameworkCore.Migrations;
using System;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddFundingAllocationPageControl : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.EnsureSchema(
                name: "FundingAllocation");

            migrationBuilder.CreateTable(
                name: "FundingAllocationPageControl",
                schema: "FundingAllocation",
                columns: table => new
                {
                    ReadId = table.Column<int>(type: "int", nullable: false),
                    PageNumber = table.Column<int>(type: "int", nullable: false),
                    LatestBookmarkOnPage = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    HaveRead = table.Column<bool>(type: "bit", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FundingAllocationPageControl", x => new { x.ReadId, x.PageNumber });
                    table.UniqueConstraint("AK_FundingAllocationPageControl_PageNumber", x => x.PageNumber);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FundingAllocationPageControl",
                schema: "FundingAllocation");
        }
    }
}
