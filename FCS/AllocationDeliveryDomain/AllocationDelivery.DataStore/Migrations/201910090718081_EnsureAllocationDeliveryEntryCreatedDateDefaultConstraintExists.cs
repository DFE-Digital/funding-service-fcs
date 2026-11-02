namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class EnsureAllocationDeliveryEntryCreatedDateDefaultConstraintExists : DbMigration
    {
        public override void Up()
        {
            Sql("IF NOT EXISTS (SELECT * FROM sys.default_constraints WHERE name = 'DF_AllocationDelivery.AllocationDeliveryEntry_CreatedDate' AND parent_object_id = OBJECT_ID('[AllocationDelivery].[AllocationDeliveryEntry]')) ALTER TABLE [AllocationDelivery].[AllocationDeliveryEntry] ADD CONSTRAINT [DF_AllocationDelivery.AllocationDeliveryEntry_CreatedDate] DEFAULT (getutcdate()) FOR [CreatedDate]");
        }
        
        public override void Down()
        {
            Sql("ALTER TABLE [AllocationDelivery].[AllocationDeliveryEntry] DROP CONSTRAINT [DF_AllocationDelivery.AllocationDeliveryEntry_CreatedDate]");
        }
    }
}
