namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule CABR-009
    /// </summary>
    public class AllocationStartDateBeforeContractStartDateRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.AllocationStartDateBeforeContractStartDate;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();

            foreach (var contract in itemToValidate.contract.contracts)
            {
                foreach (var allocation in contract.contractAllocations)
                {
                    if (allocation.startDate < contract.startDate)
                    {
                        correlationIds.Add(allocation.correlationId);
                    }
                }
            }

            return correlationIds;
        }
    }
}
