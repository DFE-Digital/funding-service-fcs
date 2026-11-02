namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SetCreatedDateToNotNull : DbMigration
    {
        public override void Up()
        {
            AlterColumn("ContractManagement.AtomFeedItem", "CreatedDate", c => c.DateTime(nullable: false));
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.AtomFeedItem", "CreatedDate", c => c.DateTime(nullable: false));
        }
    }
}
