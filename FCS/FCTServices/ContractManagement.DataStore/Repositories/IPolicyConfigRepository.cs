namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public interface IPolicyConfigRepository
    {
        IReadOnlyCollection<string> GetAllContractTypes();

        IReadOnlyCollection<string> GetAllRegionTypes();

        IReadOnlyCollection<string> GetAllContractTypes(ConnectionInfo connectionInfo);

        IReadOnlyCollection<string> GetAllRegionTypes(ConnectionInfo connectionInfo);
    }
}