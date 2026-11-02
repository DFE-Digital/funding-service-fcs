namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.ClaimTypes",
                c => new
                    {
                        ClaimTypeCode = c.String(nullable: false, maxLength: 5),
                        Name = c.String(nullable: false, maxLength: 50),
                    })
                .PrimaryKey(t => t.ClaimTypeCode);
            
        }
        
        public override void Down()
        {
            DropTable("dbo.ClaimTypes");
        }
    }
}
