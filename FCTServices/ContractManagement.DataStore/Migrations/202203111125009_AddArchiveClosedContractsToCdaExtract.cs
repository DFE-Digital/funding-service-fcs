namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddArchiveClosedContractsToCdaExtract : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.CdaExtract", "ArchiveClosedContracts", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.CdaExtract", "ArchiveClosedContracts");
        }
    }
}
