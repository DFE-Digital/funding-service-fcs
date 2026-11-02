namespace FundingAllocation.DataStore.Migrations
{
    using Microsoft.EntityFrameworkCore.Migrations;
    using System;

    public partial class CreateReleaseGroupGroup : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "ReleaseGroupGroup",
                schema: "FundingAllocation",
                columns: table => new
                {
                    GroupId = table.Column<int>(type: "int", nullable: false),
                    FundingTypeCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    FundingPeriodCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    ReleaseGroupName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ReleaseGroupGroup", x => new { x.GroupId, x.FundingTypeCode, x.FundingPeriodCode });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "ReleaseGroupGroup",
                schema: "FundingAllocation");
        }
    }
}
