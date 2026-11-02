namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FixCreateDateAtomFeedItemConstraint : DbMigration
    {
        public override void Up()
        {
            Sql(@"ALTER TABLE [ContractManagement].[AtomFeedItem] DROP CONSTRAINT IF EXISTS [DF_ContractManagement.AtomFeedItem_CreatedDate]");
            AlterColumn("ContractManagement.AtomFeedItem", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }
        
        public override void Down()
        {
            AlterColumn("ContractManagement.AtomFeedItem", "CreatedDate", c => c.DateTime(nullable: false));
            Sql(@"ALTER TABLE [ContractManagement].[AtomFeedItem] ADD  CONSTRAINT [DF_ContractManagement.AtomFeedItem_CreatedDate]  DEFAULT (getutcdate()) FOR [CreatedDate]");
        }
    }
}
