namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class ExtendStringLenthOfContractAllocationNumberAndContractNumberInApprovedTables : DbMigration
    {
        public override void Up()
        {
            DropIndex("ContractManagement.ApprovedContract", "IX_ApprovedContractNumberContractVersionContractSubversion");
            DropPrimaryKey("ContractManagement.ApprovedContractAllocation");
            AlterColumn("ContractManagement.ApprovedContractAllocation", "ContractAllocationNumber", c => c.String(nullable: false, maxLength: 50));
            AlterColumn("ContractManagement.ApprovedContract", "ContractNumber", c => c.String(maxLength: 50));
            AddPrimaryKey("ContractManagement.ApprovedContractAllocation", new[] { "ContractAllocationNumber", "ApprovedContractId" });
            CreateIndex("ContractManagement.ApprovedContract", new[] { "ContractNumber", "ContractVersionNumber", "ContractSubVersionNumber" }, unique: true, name: "IX_ApprovedContractNumberContractVersionContractSubversion");
        }
        
        public override void Down()
        {
            DropIndex("ContractManagement.ApprovedContract", "IX_ApprovedContractNumberContractVersionContractSubversion");
            DropPrimaryKey("ContractManagement.ApprovedContractAllocation");
            AlterColumn("ContractManagement.ApprovedContract", "ContractNumber", c => c.String(maxLength: 20));
            AlterColumn("ContractManagement.ApprovedContractAllocation", "ContractAllocationNumber", c => c.String(nullable: false, maxLength: 20));
            AddPrimaryKey("ContractManagement.ApprovedContractAllocation", new[] { "ContractAllocationNumber", "ApprovedContractId" });
            CreateIndex("ContractManagement.ApprovedContract", new[] { "ContractNumber", "ContractVersionNumber", "ContractSubVersionNumber" }, unique: true, name: "IX_ApprovedContractNumberContractVersionContractSubversion");
        }
    }
}
