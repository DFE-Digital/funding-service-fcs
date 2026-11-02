namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddDefaultStartDateColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "DefaultStartDate", c => c.DateTime());
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "DefaultStartDate");
        }
    }
}
