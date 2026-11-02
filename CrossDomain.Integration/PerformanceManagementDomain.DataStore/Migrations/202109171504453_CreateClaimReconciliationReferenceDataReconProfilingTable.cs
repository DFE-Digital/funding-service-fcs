namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateClaimReconciliationReferenceDataReconProfilingTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling",
                c => new
                    {
                        FundingPeriod = c.String(nullable: false, maxLength: 30),
                        Ukprn = c.Int(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.FundingPeriod, t.Ukprn });
            
        }
        
        public override void Down()
        {
            DropTable("PerformanceManagement.ClaimReconciliationReferenceDataReconProfiling");
        }
    }
}
