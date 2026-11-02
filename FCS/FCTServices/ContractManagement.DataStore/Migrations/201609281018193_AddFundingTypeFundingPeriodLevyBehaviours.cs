namespace ContractManagement.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddFundingTypeFundingPeriodLevyBehaviours : DbMigration
    {
        public override void Up()
        {
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "SkipCaseloadAssignment", c => c.Boolean(nullable: false));
            AddColumn("ContractManagement.FundingTypeFundingPeriod", "SkipReviewAndInternalApproval", c => c.Boolean(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "SkipReviewAndInternalApproval");
            DropColumn("ContractManagement.FundingTypeFundingPeriod", "SkipCaseloadAssignment");
        }
    }
}
