namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddStartDateAndEndDateToApprovedContract : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.ApprovedContract", "StartDate", c => c.DateTime());
            AddColumn("ContractManagement.ApprovedContract", "EndDate", c => c.DateTime());
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.ApprovedContract", "EndDate");
            DropColumn("ContractManagement.ApprovedContract", "StartDate");
        }
    }
}
