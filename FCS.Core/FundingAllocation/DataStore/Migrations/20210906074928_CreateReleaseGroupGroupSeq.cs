using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class CreateReleaseGroupGroupSeq : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"CREATE SEQUENCE FundingAllocation.ReleaseGroupGroupId_seq  
            START WITH 1
            INCREMENT BY 1; ");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"DROP SEQUENCE FundingAllocation.ReleaseGroupGroupId_seq ");
        }
    }
}
