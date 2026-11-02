using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class AmendSequenceReleaseGroup : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"ALTER SEQUENCE [FundingAllocation].[ReleaseGroup_seq]
            RESTART WITH 100000  
            INCREMENT BY 1; ");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"ALTER SEQUENCE [FundingAllocation].[ReleaseGroup_seq]
            RESTART WITH 1  
            INCREMENT BY 1; ");
        }
    }
}
