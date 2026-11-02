using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterReleaseGroupGroupTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_ReleaseGroupGroup",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup");

            migrationBuilder.DropColumn(
                name: "FundingTypeCode",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup");

            migrationBuilder.DropColumn(
                name: "FundingPeriodCode",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup");

            migrationBuilder.DropColumn(
                name: "ReleaseGroupName",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup");

            migrationBuilder.RenameColumn(
                name: "GroupId",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup",
                newName: "ReleaseGroupId");

            migrationBuilder.AddColumn<int>(
                name: "ReleaseGroupGroupId",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddPrimaryKey(
                name: "PK_ReleaseGroupGroup",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup",
                columns: new[] { "ReleaseGroupGroupId", "ReleaseGroupId" });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey(
                name: "PK_ReleaseGroupGroup",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup");

            migrationBuilder.DropColumn(
                name: "ReleaseGroupGroupId",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup");

            migrationBuilder.RenameColumn(
                name: "ReleaseGroupId",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup",
                newName: "GroupId");

            migrationBuilder.AddColumn<string>(
                name: "FundingTypeCode",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "FundingPeriodCode",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "ReleaseGroupName",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ReleaseGroupGroup",
                schema: "FundingAllocation",
                table: "ReleaseGroupGroup",
                columns: new[] { "GroupId", "FundingTypeCode", "FundingPeriodCode" });
        }
    }
}
