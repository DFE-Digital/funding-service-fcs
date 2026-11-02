namespace SFA.FCT.ContractRequestDomain.DataStore.Repositories
{
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IFileWatcherLockResourceRepository
    {
        bool CanAcquireLock(ConnectionInfo connectionInfo);

        ConnectionInfo GetTransactionedConnectionInfo();
    }
}