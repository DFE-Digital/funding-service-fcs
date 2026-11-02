namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ClaimReconciliationDeliverableGroup_Add_Columns : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.ClaimReconciliationDeliverableGroup", "ClaimReconciliationDeliverableGroupName", c => c.String(maxLength: 100));
            AddColumn("PerformanceManagement.ClaimReconciliationDeliverableGroup", "CapClaimToProfile", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.ClaimReconciliationDeliverableGroup", "CapClaimToProfile");
            DropColumn("PerformanceManagement.ClaimReconciliationDeliverableGroup", "ClaimReconciliationDeliverableGroupName");
        }
    }
}
