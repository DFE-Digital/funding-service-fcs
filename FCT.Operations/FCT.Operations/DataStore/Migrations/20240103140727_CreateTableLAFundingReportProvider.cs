using Microsoft.EntityFrameworkCore.Migrations;

namespace FCT.Operations.DataStore.Migrations
{
    public partial class CreateTableLAFundingReportProvider : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "LaFundingReportProvider",
                schema: "Operations",
                columns: table => new
                {
                    Ukprn = table.Column<int>(type: "int", nullable: false),
                    FundingPeriod = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Type = table.Column<string>(type: "nvarchar(30)", maxLength: 30, nullable: false),
                    Period = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.LaFundingReportProvider", x => new { x.Ukprn, x.FundingPeriod });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "LaFundingReportProvider",
                schema: "Operations");
        }
    }
}
