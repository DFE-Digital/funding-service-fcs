namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FileWatcherLockResource_ColRename : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("ContractRequest.FileWatcherLockResource");
            AddColumn("ContractRequest.FileWatcherLockResource", "Identifier", c => c.String(nullable: false, maxLength: 100));
            AddPrimaryKey("ContractRequest.FileWatcherLockResource", "Identifier");
            DropColumn("ContractRequest.FileWatcherLockResource", "Column");
            Sql(@"  IF NOT EXISTS (SELECT * FROM [ContractRequest].[FileWatcherLockResource]
                   WHERE [Identifier] = 'Lock')
            BEGIN
                insert into [ContractRequest].[FileWatcherLockResource] (Identifier)
                values ('Lock')
            END");
        }
        
        public override void Down()
        {
            AddColumn("ContractRequest.FileWatcherLockResource", "Column", c => c.String(nullable: false, maxLength: 100));
            DropPrimaryKey("ContractRequest.FileWatcherLockResource");
            DropColumn("ContractRequest.FileWatcherLockResource", "Identifier");
            AddPrimaryKey("ContractRequest.FileWatcherLockResource", "Column");
        }
    }
}
