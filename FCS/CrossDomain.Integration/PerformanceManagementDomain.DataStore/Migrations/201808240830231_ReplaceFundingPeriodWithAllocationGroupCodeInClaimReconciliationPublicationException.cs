namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class ReplaceFundingPeriodWithAllocationGroupCodeInClaimReconciliationPublicationException : DbMigration
    {
        public override void Up()
        {
            Sql("DELETE FROM PerformanceManagement.ClaimReconciliationPublicationException");

            DropPrimaryKey("PerformanceManagement.ClaimReconciliationPublicationException");
            AddColumn("PerformanceManagement.ClaimReconciliationPublicationException", "ClaimReconciliationAllocationGroupCode", c => c.String(nullable: false, maxLength: 30));
            AddPrimaryKey("PerformanceManagement.ClaimReconciliationPublicationException", new[] { "ClaimReconciliationAllocationGroupCode", "Ukprn" });
            CreateIndex("PerformanceManagement.ClaimReconciliationPublicationException", "ClaimReconciliationAllocationGroupCode");
            AddForeignKey("PerformanceManagement.ClaimReconciliationPublicationException", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup", "ClaimReconciliationAllocationGroupCode", cascadeDelete: true);
            DropColumn("PerformanceManagement.ClaimReconciliationPublicationException", "FundingPeriod");
        }
        
        public override void Down()
        {
            AddColumn("PerformanceManagement.ClaimReconciliationPublicationException", "FundingPeriod", c => c.String(nullable: false, maxLength: 10));
            DropForeignKey("PerformanceManagement.ClaimReconciliationPublicationException", "ClaimReconciliationAllocationGroupCode", "PerformanceManagement.ClaimReconciliationAllocationGroup");
            DropIndex("PerformanceManagement.ClaimReconciliationPublicationException", new[] { "ClaimReconciliationAllocationGroupCode" });
            DropPrimaryKey("PerformanceManagement.ClaimReconciliationPublicationException");
            DropColumn("PerformanceManagement.ClaimReconciliationPublicationException", "ClaimReconciliationAllocationGroupCode");
            AddPrimaryKey("PerformanceManagement.ClaimReconciliationPublicationException", new[] { "FundingPeriod", "Ukprn" });
        }
    }
}
