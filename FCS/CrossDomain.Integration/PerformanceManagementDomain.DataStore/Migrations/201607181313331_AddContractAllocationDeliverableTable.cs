namespace SFA.FCT.PerformanceManagementDomain.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class AddContractAllocationDeliverableTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PerformanceManagement.ContractAllocationDeliverable",
                c => new
                {
                    ContractAllocationNumber = c.String(nullable: false, maxLength: 20),
                    DeliverableCode = c.Int(nullable: false),
                    PlannedValue = c.Decimal(precision: 18, scale: 2),
                    CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETDATE()"),
                    LastModifiedDate = c.DateTime()
                })
                .PrimaryKey(t => new {t.ContractAllocationNumber, t.DeliverableCode});

        }
        
        public override void Down()
        {
            DropTable("PerformanceManagement.ContractAllocationDeliverable");
        }
    }
}
