namespace ContractManagement.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.AtomFeedItem",
                c => new
                {
                    Id = c.Int(nullable: false, identity: true),
                    Identifier = c.Guid(nullable: false),
                    ItemType = c.Int(nullable: false),
                    BusinessKey = c.String(),
                    AtomFeedItemXml = c.String(),
                    CreatedDate = c.DateTime(nullable: false),
                })
                .PrimaryKey(t => t.Id, clustered: false);

            CreateIndex("ContractManagement.AtomFeedItem", "CreatedDate", clustered: true,
                name: "IX_AtomFeedItem_CreatedDate");

        }
        
        public override void Down()
        {
            DropTable("ContractManagement.AtomFeedItem");
        }
    }
}
