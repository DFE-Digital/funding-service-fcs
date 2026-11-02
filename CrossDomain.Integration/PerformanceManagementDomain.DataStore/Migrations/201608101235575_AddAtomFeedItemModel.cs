namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddAtomFeedItemModel : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.AtomFeedItem",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        Identifier = c.Guid(nullable: false),
                        ItemType = c.Int(nullable: false),
                        Ukprn = c.Int(nullable: false),
                        ClaimTypeName = c.String(nullable: false, maxLength: 50),
                        AllocationGroupName = c.String(nullable: false, maxLength: 100),
                        Period = c.String(nullable: false, maxLength: 4),
                        AtomFeedItemXml = c.String(nullable: false, storeType: "xml"),
                        CreatedDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.Id)
                .Index(t => new { t.Ukprn, t.ClaimTypeName, t.AllocationGroupName, t.Period }, unique: true, name: "IX_AtomFeedNaturalKey");
            
        }
        
        public override void Down()
        {
            DropIndex("PerformanceManagement.AtomFeedItem", "IX_AtomFeedNaturalKey");
            DropTable("PerformanceManagement.AtomFeedItem");
        }
    }
}
