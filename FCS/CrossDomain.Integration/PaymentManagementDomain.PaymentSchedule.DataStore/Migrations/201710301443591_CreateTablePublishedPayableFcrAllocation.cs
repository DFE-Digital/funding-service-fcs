namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class CreateTablePublishedPayableFcrAllocation : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PaymentSchedule.PublishedPayableFcrAllocation",
                c => new
                    {
                        AllocationNumber = c.String(nullable: false, maxLength: 20),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                    })
                .PrimaryKey(t => t.AllocationNumber);
        }
        
        public override void Down()
        {
            DropTable("PaymentSchedule.PublishedPayableFcrAllocation");
        }
    }
}
