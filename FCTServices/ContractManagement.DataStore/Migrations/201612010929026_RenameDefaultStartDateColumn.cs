namespace ContractManagement.DataStore.Migrations
{
    using System.Data.Entity.Migrations;
    
    public partial class RenameDefaultStartDateColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "DefaultContractStartDate", c => c.DateTime());
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "DefaultStartDate");
        }
        
        public override void Down()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "DefaultStartDate", c => c.DateTime());
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "DefaultContractStartDate");
        }
    }
}
