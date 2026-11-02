namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddAllowProfileColumnToFspLegalDeliverable : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingStreamPeriodLegalDeliverable", "AllowProfile", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingStreamPeriodLegalDeliverable", "AllowProfile");
        }
    }
}
