using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Text;
using System.Threading.Tasks;

namespace FundingAllocation.Services
{
    public class ContractValueAggregator : IContractValueAggregator
    {
        private readonly List<string> fundingstreamToAddAggregation = new List<string> { "ASF" };
        public void Aggregate(ExtendedContractType masterContract)
        {
            // iterate over the contracts
            foreach (var contract in masterContract.contracts)
            {
                foreach (var contractAllocation in contract.contractAllocations)
                {
                    if (contractAllocation.fundingStream.fundingStreamCode.Contains(fundingstreamToAddAggregation.First()))
                    {
                        contractAllocation.maximumContractValue =
                        contractAllocation.contractDeliverables.Sum(d => d.GetDeliverableValue());
                    }
                }
                if (contract.contractAllocations.Sum(ca => ca.maximumContractValue) != 0)
                {
                    contract.contractValue = contract.contractAllocations.Sum(ca => ca.maximumContractValue);
                }
            }
        }

    }
}
