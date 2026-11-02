namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateUploadedDocumentTemplate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "DocumentsDomain.UploadedDocumentTemplate",
                c => new
                    {
                        TemplateName = c.String(nullable: false, maxLength: 100),
                        Checksum = c.Binary(maxLength: 16,  nullable: false),
                        DateUpLoaded = c.DateTime(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.TemplateName);
            
        }
        
        public override void Down()
        {
            DropTable("DocumentsDomain.UploadedDocumentTemplate");
        }
    }
}
