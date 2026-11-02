namespace PaymentGenerationDomain.Integration.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class AddLastModifiedDateToSubnominalAggregations : DbMigration
    {
        public override void Up()
        {
            AddColumn("PaymentGeneration.SubnominalAggregation", "LastModifiedDate", c => c.DateTime());

            AlterStoredProcedure("PaymentGeneration.UpdateAndSelectSubnominalAggregationByFSPCodeAndPeriod",
                                p => new
                                {
                                    fundingStreamPeriodCode = p.String(maxLength: 20),
                                    calendarPeriod = p.String(maxLength: 6),
                                },
                                body:
                    @"  UPDATE SubnominalAggregation 
	                    SET 
		                    IsSelectedForPayment = 1,
                            LastModifiedDate = GETUTCDATE()
	                    WHERE 
		                    FundingStreamPeriodCode = @fundingStreamPeriodCode
		                    AND Period = @calendarPeriod 
		                    AND AggregatedValue <> 0

	                    SELECT @@ROWCOUNT");

            AlterStoredProcedure(
                "PaymentGeneration.UpdatePaymentsToPostedForPaymentRun",
                p => new
                {
                    fundingStreamPeriodCode = p.String(maxLength: 20),
                    calendarPeriod = p.String(maxLength: 6),
                },
                body:
                    @"  UPDATE SubnominalAggregation 
	                    SET 
		                    PostedFlag = 1,
                            LastModifiedDate = GETUTCDATE()
	                    WHERE 
		                    FundingStreamPeriodCode = @fundingStreamPeriodCode
		                    AND Period = @calendarPeriod 
		                    AND AggregatedValue <> 0
		                    AND IsSelectedForPayment = 1
                        
                        SELECT @@ROWCOUNT");
        }
        
        public override void Down()
        {
            DropColumn("PaymentGeneration.SubnominalAggregation", "LastModifiedDate");

            AlterStoredProcedure("PaymentGeneration.UpdateAndSelectSubnominalAggregationByFSPCodeAndPeriod",
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

	                    SELECT @@ROWCOUNT");

            AlterStoredProcedure("PaymentGeneration.UpdatePaymentsToPostedForPaymentRun",
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
                        
                            SELECT @@ROWCOUNT");

        }
    }
}
