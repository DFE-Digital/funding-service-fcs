using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddedParkingInfoTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ParkingInfo",
                schema: "FundingAllocation",
                columns: table => new
                {
                    FundingAllocationId = table.Column<string>(type: "nvarchar(200)", nullable: false),
                    LastParked = table.Column<DateTime>(type: "datetime", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ParkingInfo", x => x.FundingAllocationId);
                    table.ForeignKey(
                        name: "FK_ParkingInfo_FundingAllocation_FundingAllocationId",
                        column: x => x.FundingAllocationId,
                        principalSchema: "FundingAllocation",
                        principalTable: "FundingAllocation",
                        principalColumn: "FundingId",
                        onDelete: ReferentialAction.Cascade);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ParkingInfo",
                schema: "FundingAllocation");
        }
    }
}
