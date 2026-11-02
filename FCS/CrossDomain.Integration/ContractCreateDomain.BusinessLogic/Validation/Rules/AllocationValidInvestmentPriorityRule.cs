namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities;

    /// <summary>
    ///     CABR-016
    /// </summary>
    public class AllocationValidInvestmentPriorityRule : IRule<contractRequestType>
    {
        private readonly List<string> _validInvestmentPriorities;

        public AllocationValidInvestmentPriorityRule(IEnumerable<string> validPriorities)
        {
            _validInvestmentPriorities = validPriorities.ToList();
        }

        public string ErrorMessage => ErrorMessages.InvestmentPriorityMustBeValid;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.GetAllocations().Where(IsInvestmentPriorityInvalid).Select(a => a.correlationId);
        }

        private bool IsInvestmentPriorityInvalid(contractAllocation a)
        {
            bool isEsfAllocation = ESFFundingStreams.FundingStreams.Contains(a.fundingStreamCode);

            return (isEsfAllocation && (string.IsNullOrWhiteSpace(a.investmentPriority) || !_validInvestmentPriorities.Contains(a.investmentPriority)))
                   || (!isEsfAllocation && !string.IsNullOrWhiteSpace(a.investmentPriority));
        }
    }
}