using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class ChangeUniqueIndexOnReleaseGroupAddStatus : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"DROP INDEX [IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_ReleasedDate]
                ON [FundingAllocation].[ReleaseGroup]");

            migrationBuilder.CreateIndex(
                name: "IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_Status_ReleasedDate",
                schema: "FundingAllocation",
                table: "ReleaseGroup",
                columns: new[] { "FundingTypeCode", "FundingPeriodCode", "FSPGroupCode", "ContractType", "Status", "ReleasedDate" },
                unique: true,
                filter: "[ReleasedDate] IS NULL");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_Status_ReleasedDate",
                schema: "FundingAllocation",
                table: "ReleaseGroup");

            migrationBuilder.Sql(@"CREATE UNIQUE NONCLUSTERED INDEX [IX_ReleaseGroup_FundingTypeCode_FundingPeriodCode_FSPGroupCode_ContractType_ReleasedDate]
                ON[FundingAllocation].[ReleaseGroup]
                ([FundingTypeCode] ASC,
                 [FundingPeriodCode] ASC,
                 [FSPGroupCode] ASC,
                 [ContractType] ASC,
                 [ReleasedDate] ASC) WHERE([ReleasedDate] IS NULL); ");
        }
    }
}
