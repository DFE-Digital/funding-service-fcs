using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterFundingAllocationPrimaryKeyToFundingId : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_FundingAllocation",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "FundingAllocationId",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.AddPrimaryKey(
                name: "PK_FundingAllocation",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "FundingId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_FundingAllocation",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.AddColumn<int>(
                name: "FundingAllocationId",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "int",
                nullable: false,
                defaultValue: 0)
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddPrimaryKey(
                name: "PK_FundingAllocation",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                column: "FundingAllocationId");
        }
    }
}
