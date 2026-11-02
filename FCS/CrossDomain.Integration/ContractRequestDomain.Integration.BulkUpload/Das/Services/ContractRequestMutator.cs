namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class ContractRequestMutator : IContractRequestMutator
    {
        private const string NonLevyFundingStreamPeriodCode = "NONLEVY2019";
        private const string NonLevyFundingStreamCode = "NONLEVY";
        private const decimal MaximumContractValue = 0.0m;

        public void AddNonLevyAllocationToContractRequest(contractRequestType contractRequestType)
        {
            contractType childContract = contractRequestType.contract.contracts.First();
            contractAllocation allocation = new contractAllocation
            {
                period = childContract.period,
                ukprn = childContract.contractor.ukprn,
                fundingStreamCode = NonLevyFundingStreamCode,
                startDate = childContract.startDate,
                maximumContractValue = MaximumContractValue,
                fundingStreamPeriodCode = NonLevyFundingStreamPeriodCode,
                contractDeliverables = new List<contractDeliverable>(),
                correlationId = Guid.NewGuid().ToString("D")
            };

            childContract.contractAllocations.Add(allocation);
        }
    }
}
