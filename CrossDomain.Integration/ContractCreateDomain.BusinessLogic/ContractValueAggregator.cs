namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.CorporateContract;
    using ContractRequest = CrossDomain.Integration.Entities.ContractRequest;

    public class ContractValueAggregator : IContractValueAggregator
    {
        public void Aggregate(ExtendedContractType masterContract)
        {
            // iterate over the contracts
            foreach (var contract in masterContract.contracts)
            {
                foreach (var contractAllocation in contract.contractAllocations)
                {
                    contractAllocation.maximumContractValue =
                        contractAllocation.contractDeliverables.Sum(d => d.GetDeliverableValue());
                }

                contract.contractValue = contract.contractAllocations.Sum(ca => ca.maximumContractValue);
            }
        }

        public void Aggregate(contractType masterContract)
        {
            // iterate over the contracts
            foreach (var contract in masterContract.contracts)
            {
                foreach (var contractAllocation in contract.contractAllocations)
                {
                    contractAllocation.maximumContractValue =
                        contractAllocation.contractDeliverables.Sum(d => d.GetDeliverableValue());
                }

                contract.contractValue = contract.contractAllocations.Sum(ca => ca.maximumContractValue);
            }
        }

        public void UpdateValueVariance(ExtendedContractType contractWithNewValues, ContractRequest.contractType contractWithOldValues)
        {
            // iterate over the contracts
            foreach (var contract in contractWithNewValues.contracts)
            {
                // get the matching contract from the contract request object (existing contract)
                ContractRequest.contractType matchingExistingContract = GetMatchingContract(contract, contractWithOldValues);
                decimal existingContractValue = matchingExistingContract.contractAllocations.Sum(ca => ca.maximumContractValue);
                contract.ValueVariation = contract.contractValue - existingContractValue;

                // iterate over contract allocations
                foreach (var allocation in contract.contractAllocations)
                {
                    ContractRequest.contractAllocation matchingExistingContractAllocation = GetMatchingAllocation(
                        allocation,
                        matchingExistingContract);
                    if (matchingExistingContractAllocation != null)
                    {
                        allocation.ValueVariation = allocation.maximumContractValue - matchingExistingContractAllocation.maximumContractValue;    
                    }
                }
            }
        }

        private ContractRequest.contractType GetMatchingContract(ExtendedContractType extendedContract, ContractRequest.contractType contractType)
        {
            return contractType.contracts.Single(c => c.contractNumber.Equals(extendedContract.contractNumber));
        }

        private ContractRequest.contractAllocation GetMatchingAllocation(ExtendedContractAllocation extendedContractAllocation, ContractRequest.contractType contractType)
        {
            if (contractType.contractAllocations.All(ca => !string.IsNullOrEmpty(ca.contractAllocationNumber)))
            {
                // we have the allocation numbers so use them
                return
               contractType.contractAllocations.FirstOrDefault(
                   ca => string.Compare(ca.contractAllocationNumber, extendedContractAllocation.contractAllocationNumber, StringComparison.OrdinalIgnoreCase) == 0);    
            }
            else
            {
                return
                contractType.contractAllocations.FirstOrDefault(
                    ca => string.Compare(ca.fundingStreamPeriodCode, extendedContractAllocation.fundingStreamPeriodCode, StringComparison.OrdinalIgnoreCase) == 0);    
            }
        }
    }
}