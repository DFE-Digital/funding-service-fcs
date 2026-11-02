namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class AllocationFundingStreamPeriodMandatoryRule : IRule<contractRequestType>
    {
        public string ErrorMessage => "Funding Stream Period should be set on Allocation";
        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;
        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.contract.contracts.SelectMany(c => c.contractAllocations)
                .Where(a => string.IsNullOrEmpty(a.fundingStreamPeriodCode))
                .Select(a => a.correlationId)
                .ToList();
        }
    }
}
