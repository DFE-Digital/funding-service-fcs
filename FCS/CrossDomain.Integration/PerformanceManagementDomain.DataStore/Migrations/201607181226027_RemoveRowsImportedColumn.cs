namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class RemoveRowsImportedColumn : DbMigration
    {
        public override void Up()
        {
            DropColumn("PerformanceManagement.FundingClaimCollectionImportInfo", "RowsImported");
        }
        
        public override void Down()
        {
            AddColumn("PerformanceManagement.FundingClaimCollectionImportInfo", "RowsImported", c => c.Int(nullable: false));
        }
    }
}
