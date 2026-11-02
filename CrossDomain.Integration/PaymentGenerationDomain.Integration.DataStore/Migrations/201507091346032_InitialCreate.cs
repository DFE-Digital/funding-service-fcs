namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "PaymentGeneration.FundingStreamPeriod",
                c => new
                    {
                        Code = c.String(nullable: false, maxLength: 20),
                        Name = c.String(nullable: false, maxLength: 100),
                        FundingStreamCode = c.String(nullable: false, maxLength: 100),
                        StartDate = c.DateTime(nullable: false, storeType: "date"),
                        EndDate = c.DateTime(nullable: false, storeType: "date"),
                        DummyAccountCode = c.String(nullable: false, maxLength: 100),
                        ControlAccountCode = c.Int(nullable: false),
                        Element1DefaultValue = c.String(nullable: false, maxLength: 100),
                    })
                .PrimaryKey(t => t.Code)
                .ForeignKey("PaymentGeneration.FundingStream", t => t.FundingStreamCode, cascadeDelete: true)
                .Index(t => t.FundingStreamCode);
            
            CreateTable(
                "PaymentGeneration.FundingStream",
                c => new
                    {
                        Code = c.String(nullable: false, maxLength: 100),
                        Name = c.String(nullable: false, maxLength: 100),
                        FinanceShortCode = c.String(nullable: false, maxLength: 100),
                        AgencyCode = c.String(nullable: false, maxLength: 100),
                    })
                .PrimaryKey(t => t.Code);
            
            CreateTable(
                "PaymentGeneration.PaymentTimetableHistory",
                c => new
                    {
                        Id = c.Int(nullable: false, identity: true),
                        HistoryTime = c.DateTime(nullable: false),
                        FundingStreamPeriodCode = c.String(),
                        CalendarPeriod = c.String(maxLength: 6),
                        Description = c.String(nullable: false, maxLength: 255),
                    })
                .PrimaryKey(t => t.Id);
            
            CreateTable(
                "PaymentGeneration.PaymentTimetable",
                c => new
                    {
                        FundingStreamPeriodCode = c.String(nullable: false, maxLength: 20),
                        CalendarPeriod = c.String(nullable: false, maxLength: 6),
                        CalendarPeriodType = c.String(nullable: false, maxLength: 10),
                        CensusEndDate = c.DateTime(nullable: false),
                        FinancialPeriod = c.String(maxLength: 6),
                        FinancialPeriodType = c.String(nullable: false, maxLength: 10),
                        PeriodStartDate = c.DateTime(nullable: false, storeType: "date"),
                        PeriodEndDate = c.DateTime(nullable: false, storeType: "date"),
                        PaymentDueDate = c.DateTime(nullable: false, storeType: "date"),
                        LinkCodeSuffix = c.String(maxLength: 1, fixedLength: true, unicode: false),
                        Status = c.String(nullable: false, maxLength: 40),
                    })
                .PrimaryKey(t => new { t.FundingStreamPeriodCode, t.CalendarPeriod })
                .ForeignKey("PaymentGeneration.FundingStreamPeriod", t => t.FundingStreamPeriodCode, cascadeDelete: true)
                .Index(t => new { t.FundingStreamPeriodCode, t.CensusEndDate }, unique: true, name: "IX_FundingStreamPeriodCodeAndCensusEndDate");
            
            CreateTable(
                "PaymentGeneration.SubnominalAggregation",
                c => new
                    {
                        AllocationNumber = c.String(nullable: false, maxLength: 20),
                        Period = c.String(nullable: false, maxLength: 6),
                        SubnominalCode = c.String(nullable: false, maxLength: 8),
                        PaymentType = c.String(nullable: false, maxLength: 20),
                        PeriodTypeCode = c.String(maxLength: 10),
                        OrganisationId = c.String(maxLength: 10),
                        FundingStreamPeriodCode = c.String(maxLength: 20),
                        Ukprn = c.Int(nullable: false),
                        PostedFlag = c.Boolean(nullable: false),
                        AggregatedValue = c.Decimal(nullable: false, precision: 18, scale: 2),
                        IsSelectedForPayment = c.Boolean(nullable: false),
                    })
                .PrimaryKey(t => new { t.AllocationNumber, t.Period, t.SubnominalCode, t.PaymentType })
                .ForeignKey("PaymentGeneration.FundingStreamPeriod", t => t.FundingStreamPeriodCode)
                .ForeignKey("PaymentGeneration.Subnominal", t => t.SubnominalCode, cascadeDelete: true)
                .Index(t => t.SubnominalCode)
                .Index(t => t.FundingStreamPeriodCode);
            
            CreateTable(
                "PaymentGeneration.Subnominal",
                c => new
                    {
                        Code = c.String(nullable: false, maxLength: 8),
                        ShortDescription = c.String(nullable: false, maxLength: 100),
                    })
                .PrimaryKey(t => t.Code);

            CreateStoredProcedure(
                "PaymentGeneration.UpdateAndSelectSubnominalAggregationByFSPCodeAndPeriod",
                p => new
                {
                    fundingStreamPeriodCode = p.String(maxLength: 20),
                    calendarPeriod = p.String(maxLength: 6),
                },
                body:
                    @"  UPDATE SubnominalAggregation 
	                    SET 
		                    IsSelectedForPayment = 1 
	                    WHERE 
		                    FundingStreamPeriodCode = @fundingStreamPeriodCode
		                    AND Period = @calendarPeriod 
		                    AND AggregatedValue <> 0

	                    SELECT @@ROWCOUNT"
             );

            CreateStoredProcedure(
                "PaymentGeneration.UpdatePaymentsToPostedForPaymentRun",
                p => new
                {
                    fundingStreamPeriodCode = p.String(maxLength: 20),
                    calendarPeriod = p.String(maxLength: 6),
                },
                body:
                    @"  UPDATE SubnominalAggregation 
	                    SET 
		                    PostedFlag = 1 
	                    WHERE 
		                    FundingStreamPeriodCode = @fundingStreamPeriodCode
		                    AND Period = @calendarPeriod 
		                    AND AggregatedValue <> 0
		                    AND IsSelectedForPayment = 1
                        
                        SELECT @@ROWCOUNT       
                     "
             );
            
        }
        
        public override void Down()
        {
            DropStoredProcedure("PaymentGeneration.UpdatePaymentsToPostedForPaymentRun");
            DropStoredProcedure("PaymentGeneration.UpdateAndSelectSubnominalAggregationByFSPCodeAndPeriod");
            DropForeignKey("PaymentGeneration.SubnominalAggregation", "SubnominalCode", "PaymentGeneration.Subnominal");
            DropForeignKey("PaymentGeneration.SubnominalAggregation", "FundingStreamPeriodCode", "PaymentGeneration.FundingStreamPeriod");
            DropForeignKey("PaymentGeneration.PaymentTimetable", "FundingStreamPeriodCode", "PaymentGeneration.FundingStreamPeriod");
            DropForeignKey("PaymentGeneration.FundingStreamPeriod", "FundingStreamCode", "PaymentGeneration.FundingStream");
            DropIndex("PaymentGeneration.SubnominalAggregation", new[] { "FundingStreamPeriodCode" });
            DropIndex("PaymentGeneration.SubnominalAggregation", new[] { "SubnominalCode" });
            DropIndex("PaymentGeneration.PaymentTimetable", "IX_FundingStreamPeriodCodeAndCensusEndDate");
            DropIndex("PaymentGeneration.FundingStreamPeriod", new[] { "FundingStreamCode" });
            DropTable("PaymentGeneration.Subnominal");
            DropTable("PaymentGeneration.SubnominalAggregation");
            DropTable("PaymentGeneration.PaymentTimetable");
            DropTable("PaymentGeneration.PaymentTimetableHistory");
            DropTable("PaymentGeneration.FundingStream");
            DropTable("PaymentGeneration.FundingStreamPeriod");
        }
    }
}
