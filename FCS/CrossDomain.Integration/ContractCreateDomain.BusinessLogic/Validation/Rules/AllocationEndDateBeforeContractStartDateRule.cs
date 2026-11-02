namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule CABR-008
    /// </summary>
    public class AllocationEndDateBeforeContractStartDateRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.AllocationEndDateBeforeContractStartDate;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();
            foreach (var contract in itemToValidate.contract.contracts)
            {
                if (contract.startDate.HasValue)
                {
                    foreach (var allocation in contract.contractAllocations)
                    {
                        if (allocation.endDate.HasValue && allocation.endDate.Value.ToUniversalTime() < contract.startDate.Value.ToUniversalTime())
                        {
                            correlationIds.Add(allocation.correlationId);
                        }
                    }
                }
            }

            return correlationIds;
        }
    }
}
