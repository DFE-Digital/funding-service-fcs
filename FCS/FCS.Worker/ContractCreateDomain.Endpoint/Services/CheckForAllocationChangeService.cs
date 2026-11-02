namespace ContractCreateDomain.Endpoint.Services
{
    using System.Linq;
    using Infrastructure;
    using DTOs;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Common.Extensions;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class CheckForAllocationChangeService : ICheckForAllocationChangeService
    {
        public void UpdateAllocationsThatHaveChangedOrBeenAdded(CrmContract crmContract, contractType importContract)
        {
            UpdateForNewAllocations(crmContract, importContract);

            UpdateForMatchingAllocations(crmContract, importContract);
        }

        private void UpdateForMatchingAllocations(CrmContract crmContract, contractType importContract)
        {
            importContract.contractAllocations.ForEach(importAllocation =>
            {
                var crmAllocationOptional = crmContract.Allocations.FirstOrDefault(ca =>
                        ca.Number == importAllocation.contractAllocationNumber).SomeWhen(a => a != null);

                crmAllocationOptional.Match(
                    some: crmAllocation => { UpdateAllocationIfItHasChanged(crmAllocation, importAllocation); },
                    none: () => importAllocation.HasBeenAdded = true);
            });
        }

        private void UpdateAllocationIfItHasChanged(CrmAllocation crmContractAllocation,
            contractAllocation importAllocation)
        {
            Either<bool, CrmAllocationAndImportAllocation> result =  new Either<bool, CrmAllocationAndImportAllocation>(
                    new CrmAllocationAndImportAllocation(crmContractAllocation, importAllocation))
                .Bind(ContractAllocationChecker.HasTheSameDeliverableCodes)
                .Bind(ContractAllocationChecker.HasTheSamePlannedValues)
                .Bind(ContractAllocationChecker.HasTheSameAllocationDates);

            result.Match(
                leftAction:failed => importAllocation.HasBeenUpdated = true,
                rightAction: passed => importAllocation.HasBeenUpdated = false);
        }

        private static void UpdateForNewAllocations(CrmContract crmContract, contractType importContract)
        {
            importContract.contractAllocations.Where(importContractAllocation => crmContract.Allocations.None(crmAllocation => crmAllocation.Number == importContractAllocation.contractAllocationNumber))
                .ToList()
                .ForEach(importContractAllocation => importContractAllocation.HasBeenAdded = true);
        }
    }
}
