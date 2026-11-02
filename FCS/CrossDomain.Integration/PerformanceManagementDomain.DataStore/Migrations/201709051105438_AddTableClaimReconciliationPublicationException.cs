namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddTableClaimReconciliationPublicationException : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.ClaimReconciliationPublicationException",
                c => new
                    {
                        FundingPeriod = c.String(nullable: false, maxLength: 10),
                        Ukprn = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.FundingPeriod, t.Ukprn });
            
        }
        
        public override void Down()
        {
            DropTable("PerformanceManagement.ClaimReconciliationPublicationException");
        }
    }
}
