namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddProcessedMessage : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "Operations.ProcessedMessage",
                c => new
                    {
                        MessageId = c.String(nullable: false, maxLength: 36),
                        ProcessingEndpoint = c.String(nullable: false, maxLength: 100),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.MessageId, t.ProcessingEndpoint });
            
        }
        
        public override void Down()
        {
            DropTable("Operations.ProcessedMessage");
        }
    }
}
