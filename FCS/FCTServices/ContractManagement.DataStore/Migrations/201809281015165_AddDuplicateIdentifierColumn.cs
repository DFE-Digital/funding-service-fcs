namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddDuplicateIdentifierColumn : DbMigration
    {
        public override void Up()
        {
            DropIndex("ContractManagement.AtomFeedItem", "IX_AtomFeedItem_ItemTypeBusinessKey");
            AddColumn("ContractManagement.AtomFeedItem", "DuplicateIdentifier", c => c.Guid(nullable: false));
            CreateIndex("ContractManagement.AtomFeedItem", new[] { "ItemType", "BusinessKey", "DuplicateIdentifier" }, unique: true, name: "IX_AtomFeedItem_ItemTypeBusinessKeyDuplicateIdentifier");
        }
        
        public override void Down()
        {
            DropIndex("ContractManagement.AtomFeedItem", "IX_AtomFeedItem_ItemTypeBusinessKeyDuplicateIdentifier");
            DropColumn("ContractManagement.AtomFeedItem", "DuplicateIdentifier");
            CreateIndex("ContractManagement.AtomFeedItem", new[] { "ItemType", "BusinessKey" }, unique: true, name: "IX_AtomFeedItem_ItemTypeBusinessKey");
        }
    }
}
