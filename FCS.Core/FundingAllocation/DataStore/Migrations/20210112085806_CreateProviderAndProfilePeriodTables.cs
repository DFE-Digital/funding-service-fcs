using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateProviderAndProfilePeriodTables : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ProviderFundingAllocation",
                schema: "FundingAllocation",
                columns: table => new
                {
                    ProviderFundingId = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    FundingId = table.Column<string>(type: "nvarchar(200)", maxLength: 200, nullable: false),
                    DeliveryUkprn = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProviderFundingAllocation", x => x.ProviderFundingId);
                    table.ForeignKey(
                        name: "FK_ProviderFundingAllocation_FundingAllocation_FundingId",
                        column: x => x.FundingId,
                        principalSchema: "FundingAllocation",
                        principalTable: "FundingAllocation",
                        principalColumn: "FundingId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "FundingAllocationProfilePeriod",
                schema: "FundingAllocation",
                columns: table => new
                {
                    ProviderFundingId = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Period = table.Column<int>(type: "int", nullable: false),
                    PlannedValue = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FundingAllocationProfilePeriod", x => new { x.ProviderFundingId, x.Period });
                    table.ForeignKey(
                        name: "FK_FundingAllocationProfilePeriod_ProviderFundingAllocation_ProviderFundingId",
                        column: x => x.ProviderFundingId,
                        principalSchema: "FundingAllocation",
                        principalTable: "ProviderFundingAllocation",
                        principalColumn: "ProviderFundingId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_ProviderFundingAllocation_FundingId",
                schema: "FundingAllocation",
                table: "ProviderFundingAllocation",
                column: "FundingId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FundingAllocationProfilePeriod",
                schema: "FundingAllocation");

            migrationBuilder.DropTable(
                name: "ProviderFundingAllocation",
                schema: "FundingAllocation");
        }
    }
}
