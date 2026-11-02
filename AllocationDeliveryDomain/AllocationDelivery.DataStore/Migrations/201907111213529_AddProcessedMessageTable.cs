namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddProcessedMessageTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "AllocationDelivery.ProcessedMessage",
                c => new
                    {
                        MessageId = c.String(nullable: false, maxLength: 36),
                    })
                .PrimaryKey(t => t.MessageId);
            
        }
        
        public override void Down()
        {
            DropTable("AllocationDelivery.ProcessedMessage");
        }
    }
}
