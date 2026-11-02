namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCreatedDateColumn : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicySubnominal", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PolicyCache.PolicyDeliverableToSubnominals", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PolicyCache.CappingGroup", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PolicyCache.PolicyDeliverable", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PolicyCache.PolicyFundingStreamPeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AddColumn("PolicyCache.PolicyFundingStreamCensusDate", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicySubnominal", "CreatedDate");
            DropColumn("PolicyCache.PolicyDeliverableToSubnominals", "CreatedDate");
            DropColumn("PolicyCache.CappingGroup", "CreatedDate");
            DropColumn("PolicyCache.PolicyDeliverable", "CreatedDate");
            DropColumn("PolicyCache.PolicyFundingStreamPeriod", "CreatedDate");
            DropColumn("PolicyCache.PolicyFundingStreamCensusDate", "CreatedDate");
        }
    }
}
