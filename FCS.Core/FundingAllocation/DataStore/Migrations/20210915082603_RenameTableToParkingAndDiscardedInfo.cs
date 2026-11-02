using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class RenameTableToParkingAndDiscardedInfo : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(
                "EXEC sp_rename 'FundingAllocation.ParkingInfo', 'ParkingAndDiscardedInfo'");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(
                "EXEC sp_rename 'FundingAllocation.ParkingAndDiscardedInfo', 'ParkingInfo'");
        }
    }
}
