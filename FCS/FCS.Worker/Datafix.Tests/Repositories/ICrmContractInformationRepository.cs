namespace Datafix.Tests.Repositories
{
    using System.Collections.Generic;
    using ContractManagement.DataStore.Model;
    using Dtos;

    public interface ICrmContractInformationRepository
    {
        IReadOnlyCollection<ContractInfo> GetLastApprovedContracts();

        ISet<ContractInfo> GetLastApprovedAndLatestVersionContractsWithoutDuplicates();

        IReadOnlyCollection<ApprovedContract> GetReplacedContracts();
    }
}