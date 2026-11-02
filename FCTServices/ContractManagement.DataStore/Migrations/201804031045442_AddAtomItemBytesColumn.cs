namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddAtomItemBytesColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.AtomFeedItem", "AtomFeedItemBytes", c => c.Binary());
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.AtomFeedItem", "AtomFeedItemBytes");
        }
    }
}
