namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddApprovedContractTableAndApprovedContractAllocationTable : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "ContractManagement.ApprovedContractAllocation",
                c => new
                    {
                        ContractAllocationNumber = c.String(nullable: false, maxLength: 20),
                        ApprovedContractId = c.Int(nullable: false),
                        HasOutstandingPayments = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => new { t.ContractAllocationNumber, t.ApprovedContractId })
                .ForeignKey("ContractManagement.ApprovedContract", t => t.ApprovedContractId, cascadeDelete: true)
                .Index(t => t.ApprovedContractId);
            
            CreateTable(
                "ContractManagement.ApprovedContract",
                c => new
                    {
                        ApprovedContractId = c.Int(nullable: false, identity: true),
                        ContractNumber = c.String(maxLength: 20),
                        ContractVersionNumber = c.Int(nullable: false),
                        ContractSubVersionNumber = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.ApprovedContractId)
                .Index(t => new { t.ContractNumber, t.ContractVersionNumber, t.ContractSubVersionNumber }, unique: true, name: "IX_ApprovedContractNumberContractVersionContractSubversion");
            
        }
        
        public override void Down()
        {
            DropForeignKey("ContractManagement.ApprovedContractAllocation", "ApprovedContractId", "ContractManagement.ApprovedContract");
            DropIndex("ContractManagement.ApprovedContract", "IX_ApprovedContractNumberContractVersionContractSubversion");
            DropIndex("ContractManagement.ApprovedContractAllocation", new[] { "ApprovedContractId" });
            DropTable("ContractManagement.ApprovedContract");
            DropTable("ContractManagement.ApprovedContractAllocation");
        }
    }
}
