namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ProcessedMessages_Table_Added : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.ProcessedMessage",
                c => new
                    {
                        MessageId = c.String(nullable: false, maxLength: 36),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => t.MessageId);
            
        }
        
        public override void Down()
        {
            DropTable("ContractManagement.ProcessedMessage");
        }
    }
}
