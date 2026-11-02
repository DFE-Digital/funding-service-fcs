namespace ContractManagement.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateIndexes : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.AtomFeedItem", "BusinessKey", c => c.String(maxLength: 100));

            CreateIndex("ContractManagement.AtomFeedItem", "ItemType", name: "IX_AtomFeedItem_ItemType");

            CreateIndex("ContractManagement.AtomFeedItem", new[] { "ItemType","BusinessKey" }, unique: true,
              name: "IX_AtomFeedItem_ItemTypeBusinessKey");
        }
        
        public override void Down()
        {
            DropIndex("ContractManagement.AtomFeedItem", "IX_AtomFeedItem_ItemTypeBusinessKey");

            DropIndex("ContractManagement.AtomFeedItem", "IX_AtomFeedItem_ItemType");

            AlterColumn("ContractManagement.AtomFeedItem", "BusinessKey", c => c.String(maxLength: int.MaxValue));
        }
    }
}
