namespace SFA.FCT.ContractRequestDomain.DataStore.Repositories
{
    using CrossDomain.Integration.Entities.Data;
    using Dapper;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using System.Linq;

    public class FundingAllocationReleaseRepository : IFundingAllocationReleaseRepository
    {

        public bool IsReleaseInProgress(string fundingTypeCode, string fundingPeriod, ConnectionInfo connectionInfo)
        {
            var releaseInProgressStatus = FundingAllocationReleaseStatus.ReleaseInProgress.ToString();
            using (var context = new ContractRequestDbContext())
            {
                var numRows = (from fa in context.FundingAllocationReleases
                              where fa.FundingTypeCode == fundingTypeCode
                              && fa.FundingPeriodName == fundingPeriod
                              && fa.ReleaseStatus == releaseInProgressStatus
                              select fa).Take(1).Count();
                return numRows > 0;
            }
            

            //const string sql = @"Select count(1) from [ContractRequest].[FundingAllocationRelease] 
            //                     where [FundingTypeCode] = @fundingTypeCode
            //                     and [FundingPeriodName] = @fundingPeriod
            //                     and [ReleaseStatus] = @releaseInProgressStatus";

            //int numRows = connectionInfo.Connection.ExecuteScalar<int>(sql,
            //    param: new {fundingTypeCode, fundingPeriod, releaseInProgressStatus },
            //    transaction:connectionInfo.Transaction);

            //return numRows > 0;
        }
    }
}
