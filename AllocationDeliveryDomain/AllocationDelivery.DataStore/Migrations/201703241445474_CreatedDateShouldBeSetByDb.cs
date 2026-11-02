namespace SFA.FCT.AllocationDelivery.DataStore.Migrations
{
    using System.Data.Entity.Migrations;

    public partial class CreatedDateShouldBeSetByDb : DbMigration
    {
        public override void Up()
        {
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()"));
        }

        public override void Down()
        {
            AlterColumn("AllocationDelivery.AllocationDeliveryEntry", "CreatedDate", c => c.DateTime(nullable: false));
        }
    }
}
