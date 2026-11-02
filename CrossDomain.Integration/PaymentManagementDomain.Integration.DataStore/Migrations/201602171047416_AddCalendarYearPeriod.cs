namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddCalendarYearPeriod : DbMigration
    {
        public override void Up()
        {
            AddColumn("PolicyCache.PolicyFundingStreamCensusDate", "CalendarYear", c => c.Int(nullable: false));
            AddColumn("PolicyCache.PolicyFundingStreamCensusDate", "CalendarPeriod", c => c.Int(nullable: false));
        }
        
        public override void Down()
        {
            DropColumn("PolicyCache.PolicyFundingStreamCensusDate", "CalendarPeriod");
            DropColumn("PolicyCache.PolicyFundingStreamCensusDate", "CalendarYear");
        }
    }
}
