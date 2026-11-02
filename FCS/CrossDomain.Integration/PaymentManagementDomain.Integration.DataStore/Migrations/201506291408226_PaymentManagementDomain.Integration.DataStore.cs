namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class PaymentManagementDomainIntegrationDataStore : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PolicyCache.PolicyDeliverable",
                c => new
                    {
                        DeliverableCode = c.Int(nullable: false),
                        FundingStreamPeriod = c.String(nullable: false, maxLength: 128),
                        Payable = c.Boolean(nullable: false),
                        PaymentSubnominal = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.DeliverableCode, t.FundingStreamPeriod })
                .Index(t => new { t.DeliverableCode, t.FundingStreamPeriod }, unique: true, name: "IX_DeliverableIndex");
            
            CreateTable(
                "PolicyCache.PolicyFundingStreamCensusDate",
                c => new
                    {
                        FundingStreamPeriod = c.String(nullable: false, maxLength: 128),
                        CensusDate = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => new { t.FundingStreamPeriod, t.CensusDate })
                .Index(t => new { t.FundingStreamPeriod, t.CensusDate }, unique: true, name: "IX_CensusIndex");
            
            CreateTable(
                "PolicyCache.PolicyFundingStreamPeriod",
                c => new
                    {
                        FundingStreamPeriod = c.String(nullable: false, maxLength: 128),
                        PaymentMethod = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.FundingStreamPeriod)
                .Index(t => t.FundingStreamPeriod, unique: true, name: "IX_FSPIndex");
            
            CreateTable(
                "PolicyCache.PolicySubnominal",
                c => new
                    {
                        PaymentSubnominal = c.Int(nullable: false),
                        PaymentSubnominalDesc = c.String(),
                        PaymentType = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.PaymentSubnominal)
                .Index(t => t.PaymentSubnominal, unique: true, name: "IX_SubnominalIndex");
            
        }
        
        public override void Down()
        {
            DropIndex("PolicyCache.PolicySubnominal", "IX_SubnominalIndex");
            DropIndex("PolicyCache.PolicyFundingStreamPeriod", "IX_FSPIndex");
            DropIndex("PolicyCache.PolicyFundingStreamCensusDate", "IX_CensusIndex");
            DropIndex("PolicyCache.PolicyDeliverable", "IX_DeliverableIndex");
            DropTable("PolicyCache.PolicySubnominal");
            DropTable("PolicyCache.PolicyFundingStreamPeriod");
            DropTable("PolicyCache.PolicyFundingStreamCensusDate");
            DropTable("PolicyCache.PolicyDeliverable");
        }
    }
}
