namespace SFA.FCT.PaymentManagementDomain.PolicyCache.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createstoreproceduretoGetFspCalcConfigInfoFromDb : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_PaymentManagement_GetFspCalcConfigInfoFromDb", c => new
            {
                fundingStreamPeriodCode = c.String(128),
                month = c.Int(),
                year = c.Int()

            }, StoredProcedureBody);
        }
        
        public override void Down()
        {
            DropStoredProcedure("dbo.sp_PaymentManagement_GetFspCalcConfigInfoFromDb");
        }

        private const string StoredProcedureBody = @"SELECT fsp.PaymentMethod,
                                               fsp.PaymentCappingPeriod, 
                                               fsp.PaymentCappingLevel,
                                               fsp.IsPrioritisedApportionment,
		                                       calc_override.PaymentCappingPeriod as OverrideCappingPeriod,
											   calc_override.CalcPolicyVersion,
											   calc_override.CappingPeriod,
											   calc_override.OverDeliveryLimit
                                      FROM PolicyCache.PolicyFundingStreamPeriod  fsp
									  LEFT JOIN (select calc_override.PaymentCappingPeriod,
									                    calc_override.CalcPolicyVersion,
														pt.FundingStreamPeriod,
														calc_cappingperiod.CappingPeriod,
														calc_cappingperiod.OverDeliveryLimit
												from [PolicyCache].[PolicyFundingStreamCensusDate] pt, 
													 [PolicyCache].[FundingStreamPeriodPayCalcPolicy] calc_override
													 left join [PolicyCache].[FundingStreamPeriodCappingPeriodPayCalcPolicy] calc_cappingperiod
													 on calc_override.FundingStreamPeriodCode = calc_cappingperiod.FundingStreamPeriodCode
													 and calc_override.CalcPolicyVersion = calc_cappingperiod.CalcPolicyVersion
		                                        where pt.FundingStreamPeriod = calc_override.FundingStreamPeriodCode
		                                        and pt.CalendarYear = @year
		                                        and pt.CalendarPeriod = @month
		                                        and pt.PayCalcPolicyVersion = calc_override.CalcPolicyVersion) calc_override								
                                      ON fsp.FundingStreamPeriod = calc_override.FundingStreamPeriod
                                      WHERE fsp.FundingStreamPeriod = @fundingStreamPeriodCode";
    }
}
