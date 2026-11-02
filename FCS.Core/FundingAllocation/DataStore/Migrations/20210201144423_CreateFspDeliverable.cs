namespace FundingAllocation.DataStore.Migrations
{
    using Microsoft.EntityFrameworkCore.Migrations;
    using System;

    public partial class CreateFspDeliverable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "FspDeliverable",
                schema: "FundingAllocation",
                columns: table => new
                {
                    FspCode = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    DeliverableCode = table.Column<int>(type: "int", nullable: false),
                    DeliverableName = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FspDeliverable", x => new { x.FspCode, x.DeliverableCode });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "FspDeliverable",
                schema: "FundingAllocation");
        }
    }
}
