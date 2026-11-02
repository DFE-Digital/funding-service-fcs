using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AlterFundingAllocationDropUnusedColumns : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CreatedBy",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "CreatedOn",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "ModifiedBy",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "ModifiedOn",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "Provider",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "Status",
                schema: "FundingAllocation",
                table: "FundingAllocation");

            migrationBuilder.DropColumn(
                name: "Substatus",
                schema: "FundingAllocation",
                table: "FundingAllocation");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "CreatedBy",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedOn",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ModifiedBy",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(100)",
                maxLength: 100,
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "ModifiedOn",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Provider",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Status",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Substatus",
                schema: "FundingAllocation",
                table: "FundingAllocation",
                type: "nvarchar(50)",
                maxLength: 50,
                nullable: true);
        }
    }
}
