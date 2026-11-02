namespace ContractRequestDomain.Cfs.Release.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Extensions;
    using MoreLinq;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using hierarchyType = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract.hierarchyType;

    public class ContractNumberEnricher : IContractNumberEnricher
    {
        private readonly INumberRequestManager _xrmNumberRequestManager;

        public ContractNumberEnricher(INumberRequestManager xrmNumberRequestManager)
        {
            _xrmNumberRequestManager = xrmNumberRequestManager;
        }

        public void EnrichWithContractAndAllocationNumbers(ExtendedContractType masterContract, ConnectionInfo connectionInfo)
        {
            List<NumberRequest> numberRequests = masterContract.ToNumberRequests();

            // this strangely named method populates the number requests
            _xrmNumberRequestManager.GetContractNumbers(numberRequests, connectionInfo);

            EnrichMasterAndChildEntitiesWithNumbers(masterContract, numberRequests);
        }

        private void EnrichMasterAndChildEntitiesWithNumbers(ExtendedContractType masterContract, List<NumberRequest> numberRequests)
        {
            string masterContractNumber = numberRequests
                .Single(n => n.ContractType == hierarchyType.MASTERCONTRACT.ToString()).ContractNumber;

            masterContract.contractNumber = masterContractNumber;

            string childContractNumber = numberRequests
                .Single(n => n.ContractType == hierarchyType.CONTRACT.ToString()).ContractNumber;

            var childContract = masterContract.contracts.First();
            childContract.contractNumber = childContractNumber;

            numberRequests.OfType<AllocationNumberRequest>().ForEach(allocationNumberRequest =>
            {
                var matchingAllocation =
                    childContract.contractAllocations.First(
                        a => a.fundingStream.fundingStreamCode == allocationNumberRequest.FundingStreamCode);

                matchingAllocation.contractAllocationNumber = allocationNumberRequest.ContractNumber;
            });
        }
    }
}
