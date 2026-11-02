namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddCreatedDateToProcessedMessage : DbMigration
    {
        public override void Up()
        {
            AddColumn("AllocationDelivery.ProcessedMessage", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }

        public override void Down()
        {
            DropColumn("AllocationDelivery.ProcessedMessage", "CreatedDate");
        }
    }
}
