namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Change_PK_PolicyFundingStreamCensusDate : DbMigration
    {
        public override void Up()
        {
            DropIndex("PolicyCache.PolicyFundingStreamCensusDate", "IX_CensusIndex");
            DropPrimaryKey("PolicyCache.PolicyFundingStreamCensusDate");
            AddPrimaryKey("PolicyCache.PolicyFundingStreamCensusDate", new[] { "FundingStreamPeriod", "CalendarYear", "CalendarPeriod" });
        }
        
        public override void Down()
        {
            DropPrimaryKey("PolicyCache.PolicyFundingStreamCensusDate");
            AddPrimaryKey("PolicyCache.PolicyFundingStreamCensusDate", new[] { "FundingStreamPeriod", "CensusDate" });
            CreateIndex("PolicyCache.PolicyFundingStreamCensusDate", new[] { "FundingStreamPeriod", "CensusDate" }, unique: true, name: "IX_CensusIndex");
        }
    }
}
