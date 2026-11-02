namespace FundingAllocation.DataStore.Migrations
{
    using Microsoft.EntityFrameworkCore.Migrations;
    public partial class CreateFkToFspDeliverable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_AllocationLineConfig_FspCode_DeliverableCode",
                schema: "FundingAllocation",
                table: "AllocationLineConfig",
                columns: new[] { "FspCode", "DeliverableCode" });

            migrationBuilder.AddForeignKey(
                name: "FK_AllocationLineConfig_FspDeliverable_FspCode_DeliverableCode",
                schema: "FundingAllocation",
                table: "AllocationLineConfig",
                columns: new[] { "FspCode", "DeliverableCode" },
                principalSchema: "FundingAllocation",
                principalTable: "FspDeliverable",
                principalColumns: new[] { "FspCode", "DeliverableCode" },
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AllocationLineConfig_FspDeliverable_FspCode_DeliverableCode",
                schema: "FundingAllocation",
                table: "AllocationLineConfig");

            migrationBuilder.DropIndex(
                name: "IX_AllocationLineConfig_FspCode_DeliverableCode",
                schema: "FundingAllocation",
                table: "AllocationLineConfig");
        }
    }
}
