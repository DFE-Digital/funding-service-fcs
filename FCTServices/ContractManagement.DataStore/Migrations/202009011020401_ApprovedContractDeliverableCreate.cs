namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ApprovedContractDeliverableCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.ApprovedContractDeliverable",
                c => new
                    {
                        ContractAllocationNumber = c.String(nullable: false, maxLength: 50),
                        ApprovedContractId = c.Int(nullable: false),
                        DeliverableCode = c.Int(nullable: false),
                        TotalPlannedValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                        PlannedValueEnvelope1 = c.Decimal(precision: 18, scale: 2),
                        PlannedValueEnvelope2 = c.Decimal(precision: 18, scale: 2),
                        CreatedDate = c.DateTime(nullable: false, defaultValueSql: "GETUTCDATE()")
                })
                .PrimaryKey(t => new { t.ContractAllocationNumber, t.ApprovedContractId, t.DeliverableCode })
                .ForeignKey("ContractManagement.ApprovedContractAllocation", t => new { t.ContractAllocationNumber, t.ApprovedContractId }, cascadeDelete: true)
                .Index(t => new { t.ContractAllocationNumber, t.ApprovedContractId });
            
        }
        
        public override void Down()
        {
            DropForeignKey("ContractManagement.ApprovedContractDeliverable", new[] { "ContractAllocationNumber", "ApprovedContractId" }, "ContractManagement.ApprovedContractAllocation");
            DropIndex("ContractManagement.ApprovedContractDeliverable", new[] { "ContractAllocationNumber", "ApprovedContractId" });
            DropTable("ContractManagement.ApprovedContractDeliverable");
        }
    }
}
