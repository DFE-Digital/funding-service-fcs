namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddIndexIX_ApprovedContractUkprn : DbMigration
    {
        public override void Up()
        {
            CreateIndex("ContractManagement.ApprovedContract", "Ukprn", name: "IX_ApprovedContractUkprn");
        }
        
        public override void Down()
        {
            DropIndex("ContractManagement.ApprovedContract", "IX_ApprovedContractUkprn");
        }
    }
}
