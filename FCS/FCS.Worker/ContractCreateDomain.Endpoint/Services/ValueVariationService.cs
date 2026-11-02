namespace ContractCreateDomain.Endpoint.Services
{
    using System.Linq;
    using SFA.FCT.ContractCreateDomain.Implementation.Persistence;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public class ValueVariationService : IValueVariationService
    {
        private readonly ILookupManager _lookupManager;

        public ValueVariationService(ILookupManager lookupManager)
        {
            _lookupManager = lookupManager;
        }

        public void UpdateValueVariation(ExtendedContractType contractWithNewValues)
        {
            foreach (var contract in contractWithNewValues.contracts)
            {
                var approvedAllocations = _lookupManager.GetAllocationsForApprovedContract(contract.contractNumber).ToList();

                decimal existingContractValue = approvedAllocations.Sum(ca => ca.MaximumContractValue);
                contract.ValueVariation = contract.contractValue - existingContractValue;

                foreach (var allocation in contract.contractAllocations)
                {
                    var matchingApprovedAllocation = approvedAllocations.SingleOrDefault(a =>
                        a.ContractAllocationNumber == allocation.contractAllocationNumber);
                    if (matchingApprovedAllocation != null)
                    {
                        allocation.ValueVariation = allocation.maximumContractValue - matchingApprovedAllocation.MaximumContractValue;
                    }
                }
            }
        }
    }
}
