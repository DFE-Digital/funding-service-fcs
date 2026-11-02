using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class ChangeUniqueIndexOnReleaseGroupAddReleasedDate : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_CrmEntityId",
                schema: "FundingAllocation",
                table: "ReleaseGroup");

            migrationBuilder.AddColumn<DateTime>(
                name: "ReleasedDate",
                schema: "FundingAllocation",
                table: "ReleaseGroup",
                type: "datetime2",
                nullable: true);

            migrationBuilder.Sql(@"CREATE UNIQUE NONCLUSTERED INDEX [IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_ReleasedDate]
            ON[FundingAllocation].[ReleaseGroup]
            ([FundingTypeCode] ASC,
             [FundingPeriodCode] ASC,
             [FSPGroupCode] ASC,
             [ContractType] ASC,
             [ReleasedDate] ASC) WHERE([ReleasedDate] IS NULL); ");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ReleasedDate",
                schema: "FundingAllocation",
                table: "ReleaseGroup");

            migrationBuilder.CreateIndex(
                name: "IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_CrmEntityId",
                schema: "FundingAllocation",
                table: "ReleaseGroup",
                columns: new[] { "FundingTypeCode", "FundingPeriodCode", "FSPGroupCode", "ContractType", "CrmEntityId" },
                unique: true);

            migrationBuilder.Sql(@"DROP INDEX [IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_ReleasedDate]
            ON[FundingAllocation].[ReleaseGroup]");
        }
    }
}
