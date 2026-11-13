using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

namespace ContractManagement.DataStore
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract;

    public interface IAtomFeedSeedRunner
    {
        void Execute(IEnumerable<Contract> seed);
        void ExecuteInParallel(IEnumerable<ContractSummary> contractSummaries);
        void PersistContracts(IEnumerable<ContractSummary> contractSummaries);
    }
}
