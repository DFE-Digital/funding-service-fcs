namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddTableClaimReconciliationReferenceDataProfile : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.ClaimReconciliationReferenceDataProfile",
                c => new
                    {
                        ClaimReconciliationDeliverableGroupCode = c.String(nullable: false, maxLength: 30),
                        Ukprn = c.Int(nullable: false),
                        PlannedValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                    })
                .PrimaryKey(t => new { t.ClaimReconciliationDeliverableGroupCode, t.Ukprn });
            
        }
        
        public override void Down()
        {
            DropTable("PerformanceManagement.ClaimReconciliationReferenceDataProfile");
        }
    }
}
