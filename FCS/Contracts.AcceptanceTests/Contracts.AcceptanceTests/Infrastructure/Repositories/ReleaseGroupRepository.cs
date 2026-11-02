using SFA.FCT.Contracts.AcceptanceTests;
namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Configuration;
    using System.Data.SqlClient;
    using Dapper;
    
    public static class ReleaseGroupRepository
    {
        public static void DeleteByBusinessKey(string fundingTypeCode, string fundingPeriod, string fspGroupCode, string contractType)
        {
            using (var connection = new SqlConnection(SFA.FCT.Contracts.AcceptanceTests.SqlConnectionStringProvider.Get("ContractManagementDbContext")))
            {
                connection.Execute("sp_DeleteByBusinessKey @fundingTypeCode,@fundingPeriod,@fspGroupCode,@contractType",
                     new { fundingTypeCode, fundingPeriod, fspGroupCode, contractType });
            }
        }

        public static bool IsReleaseGroupReleaseReleased(string releaseGroupName)
        {
            var status = GetReleaseGroupStatus(releaseGroupName);

            return status == "Released";
        }

        public static bool IsReleaseGroupReleaseInProgress(string releaseGroupName)
        {
            var status = GetReleaseGroupStatus(releaseGroupName);

            return status == "ReleaseInProgress";
        }

        public static string GetReleaseGroupStatus(string releaseGroupName)
        {
            using (var connection = new SqlConnection(SFA.FCT.Contracts.AcceptanceTests.SqlConnectionStringProvider.Get("ContractManagementDbContext")))
            {
               return connection.ExecuteScalar<string>("sp_GetReleaseGroupStatus @releaseGroupName", new { releaseGroupName });
            }
        }
    }
}