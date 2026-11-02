namespace ContractCreateDomain.Endpoint.XrmService.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using DTOs;
    using Optional;
    using Repositories;
    using SFA.FCT.ContractCreateDomain.Implementation.Entities;

    public class ContractDeDuplicationService : IContractDeDuplicationService
    {
        private readonly IContractQueryRepository _contractQueryRepository;
        private readonly IDictionary<ContractIdentity, ContractInfoResult> _contractInfoResults = new Dictionary<ContractIdentity, ContractInfoResult>();
        private readonly IContractAllocationCommandRepository _contractAllocationCommandRepository;

        public ContractDeDuplicationService(IContractQueryRepository contractQueryRepository, IContractAllocationCommandRepository contractAllocationCommandRepository)
        {
            _contractQueryRepository = contractQueryRepository;
            _contractAllocationCommandRepository = contractAllocationCommandRepository;
        }

        public bool IsAllocationPresent(ContractIdentity contractIdentity, string allocationNumber)
        {
            return GetContractInfo(contractIdentity).Match(
                some: c => c.Allocations.Select(a => a.Number).Contains(allocationNumber),
                none: () => false);
        }

        public void InsertAllocationWithoutDuplication(ContractIdentity contractIdentity, string allocationNumber, Action insert)
        {
            GetContractInfo(contractIdentity).Match(some:
                c =>
                {
                    if (c.Allocations.Select(a => a.Number).Contains(allocationNumber)) return;

                    insert();
                    var ids = _contractQueryRepository.GetAllocationIds(
                        contractNumber: contractIdentity.ContractNumber,
                        versionNumber: contractIdentity.Version,
                        subVersionNumber: contractIdentity.SubVersion,
                        allocationNumber: allocationNumber);

                    // check to see if there has now too many
                    if (ids.Count > 1)
                    {
                        ids.OrderBy(id => id)
                            .Skip(1)
                            .ToList()
                            .ForEach(_contractAllocationCommandRepository.DeleteAllocation);
                    }
                }, none: insert);
        }

        public Guid GetExistingContractId(ContractIdentity contractIdentity)
        {
            return GetContractInfo(contractIdentity).Match(
                some: c => c.ContractId,
                none: () => Guid.Empty);
        }

        private Option<CrmContractInfo> GetContractInfo(ContractIdentity contractIdentity)
        {
            if (!_contractInfoResults.ContainsKey(contractIdentity))
            {
                var contractInfoResult = new ContractInfoResult(_contractQueryRepository.GetContractInfo(
                    contractNumber: contractIdentity.ContractNumber,
                    versionNumber: contractIdentity.Version,
                    subVersionNumber: contractIdentity.SubVersion));
                string contractInfo = "None";
                contractInfoResult.ContractInfoOption.MatchSome(c =>
                    {
                        contractInfo = $"Some: {string.Join(", ", c.Allocations.Select(a => a.Number))}";
                    });
                _contractInfoResults.Add(contractIdentity, contractInfoResult);
            }

            return _contractInfoResults[contractIdentity].ContractInfoOption;
        }

        private class ContractInfoResult
        {
            public ContractInfoResult(Option<CrmContractInfo> contractInfoOption)
            {
                ContractInfoOption = contractInfoOption;
            }

            public Option<CrmContractInfo> ContractInfoOption { get; }
        }
    }
}
