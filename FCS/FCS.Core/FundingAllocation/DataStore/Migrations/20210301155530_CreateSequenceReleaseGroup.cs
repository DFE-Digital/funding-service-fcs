namespace FundingAllocation.DataStore.Migrations
{
    using Microsoft.EntityFrameworkCore.Migrations;

    public partial class CreateSequenceReleaseGroup : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"CREATE SEQUENCE FundingAllocation.ReleaseGroup_seq  
            START WITH 1
            INCREMENT BY 1; ");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"DROP SEQUENCE FundingAllocation.ReleaseGroup_seq ");
        }
    }
}
