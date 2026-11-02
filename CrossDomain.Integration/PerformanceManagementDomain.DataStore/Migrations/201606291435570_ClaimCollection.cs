namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class ClaimCollection : DbMigration
    {
        public override void Up()
        {
            RenameTable(name: "dbo.ClaimTypes", newName: "ClaimType");
            MoveTable(name: "dbo.ClaimType", newSchema: "PerformanceManagement");
            CreateTable(
                "PerformanceManagement.ClaimCollection",
                c => new
                    {
                        ClaimCollectionCode = c.String(nullable: false, maxLength: 30),
                        ClaimTypeCode = c.String(nullable: false, maxLength: 5),
                        Period = c.String(nullable: false, maxLength: 4),
                        PeriodType = c.String(nullable: false, maxLength: 2),
                    })
                .PrimaryKey(t => t.ClaimCollectionCode)
                .ForeignKey("PerformanceManagement.ClaimType", t => t.ClaimTypeCode, cascadeDelete: true)
                .Index(t => t.ClaimTypeCode);
            
        }
        
        public override void Down()
        {
            DropForeignKey("PerformanceManagement.ClaimCollection", "ClaimTypeCode", "PerformanceManagement.ClaimType");
            DropIndex("PerformanceManagement.ClaimCollection", new[] { "ClaimTypeCode" });
            DropTable("PerformanceManagement.ClaimCollection");
            MoveTable(name: "PerformanceManagement.ClaimType", newSchema: "dbo");
            RenameTable(name: "dbo.ClaimType", newName: "ClaimTypes");
        }
    }
}
