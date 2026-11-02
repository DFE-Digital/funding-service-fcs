namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AlterCreatedDateColumn : DbMigration
    {
        public override void Up()
        {
            AlterColumn("PolicyCache.PolicySubnominal", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("PolicyCache.PolicyDeliverableToSubnominals", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("PolicyCache.CappingGroup", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("PolicyCache.PolicyDeliverable", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("PolicyCache.PolicyFundingStreamPeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
            AlterColumn("PolicyCache.PolicyFundingStreamCensusDate", "CreatedDate", c => c.DateTime(nullable: false, defaultValueSql: "GETDATE()"));
        }
        
        public override void Down()
        {
            AlterColumn("PolicyCache.PolicySubnominal", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AlterColumn("PolicyCache.PolicyDeliverableToSubnominals", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AlterColumn("PolicyCache.CappingGroup", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AlterColumn("PolicyCache.PolicyDeliverable", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AlterColumn("PolicyCache.PolicyFundingStreamPeriod", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
            AlterColumn("PolicyCache.PolicyFundingStreamCensusDate", "CreatedDate", c => c.DateTime(nullable: false, defaultValue: DateTime.UtcNow));
        }
    }
}
