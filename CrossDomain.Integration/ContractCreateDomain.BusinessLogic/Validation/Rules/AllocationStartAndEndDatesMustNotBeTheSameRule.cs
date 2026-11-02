namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CABR-011. Start and end date same for Allocations.
    /// </summary>
    public class AllocationStartAndEndDatesMustNotBeTheSameRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.AllocationStartAndEndDatesMatchError;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();
            foreach (var allocation in itemToValidate.GetAllocations())
            {
                if (allocation.startDate == allocation.endDate)
                {
                    correlationIds.Add(allocation.correlationId);
                }
            }

            return correlationIds;
        }
    }
}