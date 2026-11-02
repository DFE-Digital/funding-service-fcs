namespace Operations.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateIndexOnAuditMessage : DbMigration
    {
        public override void Up()
        {
            Sql(@"CREATE INDEX IX_AUDITMESSAGE_CREATED_DATE ON [Operations].[AuditMessage](CreatedDate)");
        }
        
        public override void Down()
        {
            Sql(@"DROP INDEX IX_AUDITMESSAGE_CREATED_DATE ON [Operations].[AuditMessage]");
        }
    }
}
