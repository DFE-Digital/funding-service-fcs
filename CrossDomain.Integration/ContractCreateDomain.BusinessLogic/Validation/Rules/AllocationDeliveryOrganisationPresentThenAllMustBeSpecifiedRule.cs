namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Common.Extensions;
    using CrossDomain.Integration.Entities.ContractRequest;
    using Validation;

    /// <summary>
    /// Rule CABR-026
    /// </summary>
    public class AllocationDeliveryOrganisationPresentThenAllMustBeSpecifiedRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.AllocationDeliveryOrganisationPresentThenAllMustBeSpecified;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            IReadOnlyCollection<contractAllocation> allocations = contractRequest.GetAllocations().ToList();

            if (allocations.All(HasDeliveryOrganisation) || allocations.None(HasDeliveryOrganisation))
            {
                return Enumerable.Empty<string>();
            }

            return allocations.Select(a => a.correlationId);
        }

        private static bool HasDeliveryOrganisation(contractAllocation allocation)
        {
            return !string.IsNullOrEmpty(allocation.DeliveryOrganisation);
        }
    }
}
