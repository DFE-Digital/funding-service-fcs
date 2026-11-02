namespace SFA.FCT.ContractRequestDomain.DataStore.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class createstoreproceduretoSetToReleaseInProgress : DbMigration
    {
        public override void Up()
        {
            CreateStoredProcedure("dbo.sp_ContractRequest_SetToReleaseInProgress", c => new
            {
                releaseGroupGroupId = c.Int(10),
                fundingTypeCode = c.String(100),
                fundingPeriodName = c.String(100),
                releaseStatus = c.String(100)

            }, StoredProcedureBody);
        }
        
        public override void Down()
        {
            DropStoredProcedure("dbo.sp_ContractRequest_SetToReleaseInProgress");
        }

        private const string StoredProcedureBody = @"BEGIN
                                  IF NOT EXISTS (select 1 from [ContractRequest].[FundingAllocationRelease] r
									                                 where r.[ReleaseGroupGroupId] = @releaseGroupGroupId
																	 and r.[FundingTypeCode] = @fundingTypeCode
									                                 and r.[FundingPeriodName] = @fundingPeriodName
									                                 and r.[ReleaseStatus] = @releaseStatus)
		                                BEGIN
			                                INSERT INTO [ContractRequest].[FundingAllocationRelease]
                                                                            ([ReleaseGroupGroupId], [FundingTypeCode],[FundingPeriodName],[ReleaseStatus])
                                                                     VALUES (@releaseGroupGroupId, @fundingTypeCode , @fundingPeriodName, @releaseStatus)

		                                END
                                  END";
    }
}
