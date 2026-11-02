namespace ContractManagement.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class PolicyConfigRepository : IPolicyConfigRepository
    {
        private readonly IContractManagementDbContext _contractManagementDbContext;

        public PolicyConfigRepository(IContractManagementDbContext contractManagementDbContext)
        {
            _contractManagementDbContext = contractManagementDbContext;
        }

        public IReadOnlyCollection<string> GetAllContractTypes()
        {
            return _contractManagementDbContext.ContractTypes
                .Select(ct => ct.ContractTypeName)
                .ToList();
        }

        public IReadOnlyCollection<string> GetAllContractTypes(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return new PolicyConfigRepository(context).GetAllContractTypes();
            }
        }

        public IReadOnlyCollection<string> GetAllRegionTypes()
        {
            return _contractManagementDbContext.RegionTypes
                .Select(rt => rt.RegionTypeName)
                .ToList();
        }

        public IReadOnlyCollection<string> GetAllRegionTypes(ConnectionInfo connectionInfo)
        {
            using (var context = new ContractManagementDbContext(connectionInfo.Connection, connectionInfo.Transaction))
            {
                return new PolicyConfigRepository(context).GetAllRegionTypes();
            }
        }
    }
}