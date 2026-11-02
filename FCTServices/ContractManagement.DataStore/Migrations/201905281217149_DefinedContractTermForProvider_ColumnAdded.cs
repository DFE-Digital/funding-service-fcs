namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DefinedContractTermForProvider_ColumnAdded : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriodContractType", "DefinedContractTermForProvider", c => c.String(nullable: false, maxLength: 100));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingTypeFundingPeriodContractType", "DefinedContractTermForProvider");
        }
    }
}
