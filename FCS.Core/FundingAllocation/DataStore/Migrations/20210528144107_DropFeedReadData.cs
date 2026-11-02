using Microsoft.EntityFrameworkCore.Migrations;

namespace FundingAllocation.DataStore.Migrations
{
    public partial class DropFeedReadData : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("delete from [FundingAllocation].[FeedRead]");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
