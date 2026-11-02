namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.FundingAllocationRelease.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Threading.Tasks;
    using Dapper;
    using DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Linq;
    using System.Data.Entity;
    public class FundingAllocationReleaseRepository : IFundingAllocationReleaseRepository
    {
        public async Task SetToReleaseInProgress(int releaseGroupGroupId, string fundingTypeCode, string fundingPeriodName, ConnectionInfo connectionInfo)
        {
            var releaseStatus = FundingAllocationReleaseStatus.ReleaseInProgress.ToString();           
            await connectionInfo.Connection.ExecuteAsync("dbo.sp_ContractRequest_SetToReleaseInProgress @releaseGroupGroupId,@fundingTypeCode,@fundingPeriodName,@releaseStatus", new {releaseGroupGroupId, fundingTypeCode, fundingPeriodName, releaseStatus}, transaction:connectionInfo.Transaction);
        }

        public async Task SetToReleased(int releaseGroupGroupId,  ConnectionInfo connectionInfo)
        {
            var releaseStatus = FundingAllocationReleaseStatus.Released.ToString();
           
            const string sql = @"UPDATE [ContractRequest].[FundingAllocationRelease]
                                    SET [ReleaseStatus] = @releaseStatus
                                  WHERE [ReleaseGroupGroupId] = @releaseGroupGroupId";

            await connectionInfo.Connection.ExecuteAsync(sql, new {releaseGroupGroupId, releaseStatus}, transaction:connectionInfo.Transaction);
        }
    }
}