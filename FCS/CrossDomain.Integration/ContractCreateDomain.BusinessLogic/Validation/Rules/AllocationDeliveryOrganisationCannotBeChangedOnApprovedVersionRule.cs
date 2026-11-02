namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using MoreLinq;

    /// <summary>
    /// Rule CABR-025
    /// </summary>
    public class AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule : IRule<contractRequestType>
    {
        private readonly IReadOnlyCollection<ContractIdentityInfo> _lastApprovedContractIdentityInfos;

        public AllocationDeliveryOrganisationCannotBeChangedOnApprovedVersionRule(IReadOnlyCollection<ContractIdentityInfo> lastApprovedContractIdentityInfos)
        {
            _lastApprovedContractIdentityInfos = lastApprovedContractIdentityInfos;
        }
        
        public string ErrorMessage => ErrorMessages.DeliveryOrganisationCannotBeChangedOrRemovedOnApprovedContractAllocation;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            List<string> failures = new List<string>();

            contractRequest.GetSubContracts().ForEach(childContract =>
            {
                ContractIdentityInfo lastApprovedContractIdentityInfo =
                    _lastApprovedContractIdentityInfos.SingleOrDefault(c => c.ContractNumber == childContract.contractNumber) ?? ContractIdentityInfo.Empty;

                failures.AddRange(
                    childContract.contractAllocations
                    .Where(a => HasApprovedAllocationDeliveryOrgChanged(lastApprovedContractIdentityInfo, a))
                    .Select(a => a.correlationId));

                if (LastApprovedVersionHasNoDeliveryOrgs(lastApprovedContractIdentityInfo))
                {
                    failures.AddRange(
                        childContract.contractAllocations
                        .Where(a => AllocationExistsInLastApprovedVersion(lastApprovedContractIdentityInfo, a))
                        .Where(a => HasNonContractingDeliveryOrgBeenAdded(a.DeliveryOrganisation, contractRequest.contract.contractor.ukprn))
                        .Select(a => a.correlationId));
                }
            });

            return failures;
        }

        private static bool AllocationExistsInLastApprovedVersion(ContractIdentityInfo lastApprovedContractIdentityInfo, contractAllocation allocation)
        {
            return lastApprovedContractIdentityInfo.Allocations.Any(a => a.AllocationNumber == allocation.contractAllocationNumber);
        }

        private static bool HasApprovedAllocationDeliveryOrgChanged(ContractIdentityInfo lastApprovedContractIdentityInfo, contractAllocation allocation)
        {
            bool hasApprovedAllocationDeliveryOrgChanged =
                lastApprovedContractIdentityInfo.Allocations
                    .Where(ia => !string.IsNullOrEmpty(ia.DeliveryOrganisation))
                    .Any(ia => allocation.contractAllocationNumber == ia.AllocationNumber && allocation.DeliveryOrganisation != ia.DeliveryOrganisation);

            return hasApprovedAllocationDeliveryOrgChanged;
        }

        private static bool LastApprovedVersionHasNoDeliveryOrgs(ContractIdentityInfo lastApprovedContractIdentityInfo)
        {
            return
                lastApprovedContractIdentityInfo.Allocations.Any() &&
                lastApprovedContractIdentityInfo.Allocations.All(ia => string.IsNullOrEmpty(ia.DeliveryOrganisation));
        }

        private static bool HasNonContractingDeliveryOrgBeenAdded(string deliveryOrganisation, int contractorUkprn)
        {
            return !string.IsNullOrEmpty(deliveryOrganisation)
                && deliveryOrganisation != contractorUkprn.ToString();
        }
    }
}