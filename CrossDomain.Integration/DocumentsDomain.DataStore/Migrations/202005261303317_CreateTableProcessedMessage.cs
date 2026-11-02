namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;

    public partial class CreateTableProcessedMessage : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                    "DocumentsDomain.ProcessedMessage",
                    c => new
                    {
                        MessageId = c.String(false, 36),
                        ProcessingEndpoint = c.String(false, 100),
                        CreatedDate = c.DateTime(false, defaultValueSql: "GETUTCDATE()")
                    })
                .PrimaryKey(t => new {t.MessageId, t.ProcessingEndpoint});
        }

        public override void Down()
        {
            DropTable("DocumentsDomain.ProcessedMessage");
        }
    }
}