namespace DocGenTests.Infrastructure
{
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public static class ContractValueAggregator 
    {
        public static void Aggregate(ExtendedContractType masterContract)
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
    }
}
