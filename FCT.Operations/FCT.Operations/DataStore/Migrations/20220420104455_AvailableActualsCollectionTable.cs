using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FCT.Operations.DataStore.Migrations
{
    public partial class AvailableActualsCollectionTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AvailableActualsCollection",
                schema: "Operations",
                columns: table => new
                {
                    CollectionType = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    CollectionReturnCode = table.Column<string>(type: "nvarchar(20)", maxLength: 20, nullable: false),
                    ClosedDateTime = table.Column<DateTime>(type: "datetime", nullable: false),
                    TotalItems = table.Column<int>(type: "int", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.AvailableActualsCollection", x => new { x.CollectionType, x.CollectionReturnCode });
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AvailableActualsCollection",
                schema: "Operations");
        }
    }
}
