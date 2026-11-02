using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class ReleaseGroupTableAddStatusAndReleaseGroupName : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ReleaseGroupName",
                schema: "FundingAllocation",
                table: "ReleaseGroup",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Status",
                schema: "FundingAllocation",
                table: "ReleaseGroup",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_ReleaseGroup_ReleaseGroupName",
                schema: "FundingAllocation",
                table: "ReleaseGroup",
                column: "ReleaseGroupName",
                unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_ReleaseGroup_ReleaseGroupName",
                schema: "FundingAllocation",
                table: "ReleaseGroup");

            migrationBuilder.DropColumn(
                name: "ReleaseGroupName",
                schema: "FundingAllocation",
                table: "ReleaseGroup");

            migrationBuilder.DropColumn(
                name: "Status",
                schema: "FundingAllocation",
                table: "ReleaseGroup");
        }
    }
}
