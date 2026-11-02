namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddArchivedDocumentTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "DocumentsDomain.ArchivedDocument",
                c => new
                    {
                        Key = c.Guid(nullable: false),
                        FileName = c.String(nullable: false, maxLength: 150),
                        AmendmentType = c.Int(nullable: false),
                        EventType = c.Int(nullable: false),
                        FolderOrigin = c.String(nullable: false, maxLength: 150),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.Key);
            
        }
        
        public override void Down()
        {
            DropTable("DocumentsDomain.ArchivedDocument");
        }
    }
}
