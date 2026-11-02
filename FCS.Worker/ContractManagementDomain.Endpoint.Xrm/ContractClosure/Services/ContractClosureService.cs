namespace ContractManagementDomain.Endpoint.Xrm.ContractClosure.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm.OptionSets;

    public class ContractClosureService : IContractClosureService
    {
        private readonly ICrmContractRepository _crmContractRepository;

        public ContractClosureService(ICrmContractRepository crmContractRepository)
        {
            _crmContractRepository = crmContractRepository;
        }

        public void CloseContractInCrm(string contractNumber, int versionNumber, int subVersionNumber, DateTime closureDate, bool isContractOpenEnded)
        {
            bool isContractAlreadyClosed = _crmContractRepository.IsContractClosed(contractNumber);

            if (!isContractAlreadyClosed)
            {
                Guid contractId = _crmContractRepository.GetContractId(contractNumber, versionNumber, subVersionNumber);

                sfa_contract updatedContract = new sfa_contract
                {
                    Id = contractId,
                    sfa_ServiceResponse = new OptionSetValue((int)sfa_serviceresponse.ContractClosureSuccessful)
                };

                if (isContractOpenEnded)
                {
                    updatedContract.sfa_EndDate = closureDate;

                    IReadOnlyCollection<Guid> allocationIds = _crmContractRepository.GetAllocationIdsForContract(contractNumber, versionNumber, subVersionNumber);

                    updatedContract.sfa_sfa_contract_sfa_contractallocation = allocationIds.Select(allocationId => new sfa_contractallocation
                    {
                        Id = allocationId,
                        sfa_enddate = closureDate
                    }).ToList();
                }

                _crmContractRepository.UpdateContract(updatedContract);
            }
        }
    }
}
