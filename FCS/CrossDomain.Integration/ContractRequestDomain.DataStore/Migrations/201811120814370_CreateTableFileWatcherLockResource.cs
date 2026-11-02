namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateTableFileWatcherLockResource : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractRequest.FileWatcherLockResource",
                c => new
                    {
                        Column = c.String(nullable: false, maxLength: 100),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.Column);
            
        }
        
        public override void Down()
        {
            DropTable("ContractRequest.FileWatcherLockResource");
        }
    }
}
