using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FCT.Operations.DataStore.Migrations
{
    public partial class NewTableConnectivity : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Connectivity",
                schema: "Operations",
                columns: table => new
                {
                    ServiceName = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    CanConnect = table.Column<bool>(type: "bit", nullable: false),
                    ErrorInfo = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    SupplementaryInfo = table.Column<string>(type: "nvarchar(500)", maxLength: 500, nullable: true),
                    LastUpdated = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Operations.Connectivity", x => x.ServiceName);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Connectivity",
                schema: "Operations");
        }
    }
}
