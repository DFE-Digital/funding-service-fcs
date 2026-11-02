namespace FCT.Operations.Connectivity.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using System.Threading.Tasks;

    public interface IConnectivityRepository
    {
        Task InsertOrUpdateConnectivity(string serviceName, bool canConnect, string errorInfo, string supplementaryInfo, ConnectionInfo connectionInfo);
    }
}