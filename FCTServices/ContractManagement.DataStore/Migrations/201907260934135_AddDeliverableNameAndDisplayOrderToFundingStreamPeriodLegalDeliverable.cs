namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddDeliverableNameAndDisplayOrderToFundingStreamPeriodLegalDeliverable : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingStreamPeriodLegalDeliverable", "DeliverableName", c => c.String(maxLength: 100));
            AddColumn("ContractManagement.FundingStreamPeriodLegalDeliverable", "DisplayOrder", c => c.Int(nullable: false, defaultValue: 0));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingStreamPeriodLegalDeliverable", "DisplayOrder");
            DropColumn("ContractManagement.FundingStreamPeriodLegalDeliverable", "DeliverableName");
        }
    }
}
