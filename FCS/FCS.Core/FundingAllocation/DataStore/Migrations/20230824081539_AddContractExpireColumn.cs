using Microsoft.EntityFrameworkCore.Migrations;
using System;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AddContractExpireColumn : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
              name: "ContractExpiryDate",
              schema: "FundingAllocation",
              table: "FundingTypeFundingPeriodConfig",
              type: "datetime",
              nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
             name: "ContractExpiryDate",
             schema: "FundingAllocation",
             table: "FundingTypeFundingPeriodConfig");            
        }
    }
}
