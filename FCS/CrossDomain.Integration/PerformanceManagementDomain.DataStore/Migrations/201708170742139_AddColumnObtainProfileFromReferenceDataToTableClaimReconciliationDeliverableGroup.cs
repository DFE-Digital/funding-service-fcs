namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddColumnObtainProfileFromReferenceDataToTableClaimReconciliationDeliverableGroup : DbMigration
    {
        public override void Up()
        {
            AddColumn("PerformanceManagement.ClaimReconciliationDeliverableGroup", "ObtainProfileFromReferenceData", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PerformanceManagement.ClaimReconciliationDeliverableGroup", "ObtainProfileFromReferenceData");
        }
    }
}
