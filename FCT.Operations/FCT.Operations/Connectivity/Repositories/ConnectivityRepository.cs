namespace FCT.Operations.Connectivity.Repositories
{
    using System.Threading.Tasks;
    using Dapper;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ConnectivityRepository : IConnectivityRepository
    {
        public async Task InsertOrUpdateConnectivity(string serviceName, bool canConnect, string errorInfo, string supplementaryInfo, ConnectionInfo connectionInfo)
        {
            await connectionInfo.Connection.ExecuteAsync("sp_Operations_InsertOrUpdateConnectivity @serviceName,@canConnect,@errorInfo,@supplementaryInfo", new { serviceName, canConnect, errorInfo, supplementaryInfo }, connectionInfo.Transaction);
        }
    }
}