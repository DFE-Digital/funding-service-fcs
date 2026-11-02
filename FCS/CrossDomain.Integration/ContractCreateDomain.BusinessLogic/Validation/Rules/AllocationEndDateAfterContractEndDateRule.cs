namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule CABR-007
    /// </summary>
    public class AllocationEndDateAfterContractEndDateRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.AllocationEndDateAfterContractEndDate;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> correlationIds = new List<string>();
            foreach (var contract in itemToValidate.GetSubContracts())
            {
                if (contract.endDate.HasValue)
                {
                    correlationIds.AddRange(contract
                        .contractAllocations
                        .Where(al => al.endDate.HasValue && al.endDate.Value.ToUniversalTime() > contract.endDate.Value.ToUniversalTime())
                        .Select(al => al.correlationId));
                }
            }

            return correlationIds;
        }
    }
}
