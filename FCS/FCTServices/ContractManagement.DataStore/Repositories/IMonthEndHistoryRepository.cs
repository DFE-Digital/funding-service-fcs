namespace ContractManagement.DataStore.Repositories
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IMonthEndHistoryRepository
    {
        void StartMonthEnd(ConnectionInfo connectionInfo);

        void StopMonthEnd(ConnectionInfo connectionInfo);

        bool IsMonthEndInProgress(ConnectionInfo connectionInfo);

        DateTime? GetCurrentMonthEndStartTime(ConnectionInfo connectionInfo);
    }
}
