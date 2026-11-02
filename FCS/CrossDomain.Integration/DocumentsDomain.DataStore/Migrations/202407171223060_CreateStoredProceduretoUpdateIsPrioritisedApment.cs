namespace SFA.FCT.DocumentsDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CreateStoredProceduretoUpdateIsPrioritisedApment : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_Policycache_UpdateIsPrioritisedApment", StoredProcedureBody);
        }

        public override void Down()
        {
            DropStoredProcedure("dbo.sp_Policycache_UpdateIsPrioritisedApment");
        }

        private const string StoredProcedureBody = @"UPDATE PolicyCache.PolicyFundingStreamPeriod 
                                 SET IsPrioritisedApportionment = 
	                                 CAST(CASE WHEN EXISTS (SELECT 1 from  PolicyCache.PolicyDeliverable  
						                                    WHERE FundingStreamPeriod = pfsp.FundingStreamPeriod	
						                                    AND CappingApportionmentPriorityOrder > 1)
		 	                                    THEN 1 
			                                    ELSE 0 			
			                                    END AS BIT)
                                 FROM PolicyCache.PolicyFundingStreamPeriod pfsp";
    }
}
