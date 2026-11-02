namespace Operations.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AuditTableCompositeKey : DbMigration
    {
        public override void Up()
        {
            DropPrimaryKey("Operations.AuditMessage");
            AddPrimaryKey("Operations.AuditMessage", new[] { "MessageId", "ProcessingEndpoint" });
        }
        
        public override void Down()
        {
            DropPrimaryKey("Operations.AuditMessage");
            AddPrimaryKey("Operations.AuditMessage", "MessageId");
        }
    }
}
