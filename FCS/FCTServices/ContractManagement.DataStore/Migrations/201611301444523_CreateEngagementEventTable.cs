namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateEngagementEventTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.EngagementEvent",
                c => new
                    {
                        EventId = c.Long(nullable: false),
                        EventType = c.String(nullable: false, maxLength: 30),
                        ProviderId = c.String(nullable: false, maxLength: 10),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"),
                    })
                .PrimaryKey(t => t.EventId);
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.EngagementEvent");
        }
    }
}
