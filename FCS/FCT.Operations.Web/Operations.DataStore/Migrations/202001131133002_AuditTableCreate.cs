namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AuditTableCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.AuditMessage",
                c => new
                    {
                        MessageId = c.Guid(nullable: false),
                        MessageType = c.String(nullable: false, maxLength: 120),
                        SentTime = c.DateTime(nullable: false),
                        OriginatingEndpoint = c.String(nullable: false, maxLength: 100),
                        ProcessingEndpoint = c.String(nullable: false, maxLength: 100),
                        BusinessKey = c.String(nullable: false, maxLength: 80),
                        MessageBytes = c.Binary(nullable: false),
                        PropertiesBytes = c.Binary(nullable: false),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.MessageId)
                .Index(t => t.MessageType, name: "IX_AuditMessage_MessageType");
        }
        
        public override void Down()
        {
            DropIndex("Operations.AuditMessage", "IX_AuditMessage_MessageType");
            DropTable("Operations.AuditMessage");
        }
    }
}
