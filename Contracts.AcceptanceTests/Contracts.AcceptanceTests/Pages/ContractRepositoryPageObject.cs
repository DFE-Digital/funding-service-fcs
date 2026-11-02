namespace SFA.FCT.Contracts.AcceptanceTests.Pages
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using Infrastructure.Repositories;
    using MoreLinq;
    using Utilities;

    public class ContractRepositoryPageObject : IContractRepositoryPageObject
    {
        public sfa_contract RetrieveLatestContractDataAndSetState(string ukprn, string fundingType, string period)
        {
            sfa_contract matchingContract = PollToRetrieveLatestContract(ukprn, fundingType, period);

            if (matchingContract != null)
            {
                sfa_contract matchingMasterContract = CrmContractRepository.GetContract(matchingContract.sfa_ParentContractId.Id);
                IReadOnlyCollection<sfa_contractallocation> allocations = CrmContractRepository.GetAllocationsForContract(matchingContract.Id);

                FeatureVariables.Set("ContractNo", matchingContract.sfa_number);
                FeatureVariables.Set("ContractVersionNumber",  matchingContract.sfa_Version.ToString());
                FeatureVariables.Set("MasterContractNo", matchingMasterContract.sfa_number);
                FeatureVariables.Set("AllocRef", allocations.First().sfa_contractallocationnumber);
                FeatureVariables.Set("Ukprn", ukprn);
                FeatureVariables.Set("UPIN", CrmContractRepository.GetAccountForContract(matchingContract.sfa_ProviderName.Id).sfa_orgupin);

                allocations
                    .Select(a => a.sfa_contractallocationnumber)
                    .ForEach(allocationNumber =>
                    {
                        string allocationKey = "AllocRef_" + allocationNumber.Substring(0, allocationNumber.IndexOf("-", StringComparison.Ordinal));
                        FeatureVariables.Set(allocationKey, allocationNumber);
                    });
            }

            return matchingContract;
        }

        public sfa_contract PollToRetrieveLatestContract(string ukprn, string fundingType, string period)
        {
            sfa_contract matchingContract = null;

            CheckResultPoller checkResultPoller = new CheckResultPoller(
                checkResult: () =>
                {
                    matchingContract = CrmContractRepository.GetLatestContract(ukprn, fundingType, period, sfa_contracthierarchytype.Contract);
                    return matchingContract != null && CrmContractRepository.GetAllocationsForContract(matchingContract.Id).Any();
                },
                maxNumChecks: 20,
                waitIntervalSeconds: 4);

            checkResultPoller.CheckResultAndWaitTillCompleteOrOutOfTime();

            return matchingContract;
        }

        public string GetFileNameFromLatestContractData()
        {
            // the filename looks like this '10017851_' & 'ContractNo' & '_v1.pdf'
            return $"{GetLatestContractDataItem("Ukprn")}_{GetLatestContractDataItem("ContractNo")}_v{GetLatestContractDataItem("ContractVersionNumber")}.pdf";
        }

        public string GetFileNameFromLatestContractData(string ukprn, string contractNumber, string contractVersionNumber)
        {
            // the filename looks like this '10017851_' & 'ContractNo' & '_v1.pdf'
            return $"{ukprn}_{contractNumber}_v{contractVersionNumber}.pdf";
        }

        public string GetLatestContractDataItem(string dataItemIdentifier)
        {
            return FeatureVariables.Get(dataItemIdentifier);
        }
    }
}
