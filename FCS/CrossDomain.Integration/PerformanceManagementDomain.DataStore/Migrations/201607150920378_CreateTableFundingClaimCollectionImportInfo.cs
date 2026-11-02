namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableFundingClaimCollectionImportInfo : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.FundingClaimCollectionImportInfo",
                c => new
                    {
                        PeriodClaimType = c.String(nullable: false, maxLength: 50),
                        LastSuccessfulRunDate = c.DateTime(),
                        TotalRowsToImport = c.Int(nullable: false),
                        RowsImported = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.PeriodClaimType);
            
        }
        
        public override void Down()
        {
            DropTable("PerformanceManagement.FundingClaimCollectionImportInfo");
        }
    }
}
