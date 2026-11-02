namespace PerformanceManagementDomain.PullFundingClaim.Repositories
{
    using System;
    using System.Threading.Tasks;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;

    public interface IFundingClaimImportInfoRepository
    {
        Task<DateTime> GetLastCompletedImportDateOrDefault(ConnectionInfo connectionInfo);
        
        Task Add(string periodClaimType, int totalRows, ConnectionInfo connectionInfo);

        Task<FundingClaimCollectionImportInfo> Find(string periodClaimType, ConnectionInfo connectionInfo);

        Task SetToComplete(string periodClaimType, DateTime completedDate, ConnectionInfo connectionInfo);
    }
}