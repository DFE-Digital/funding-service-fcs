namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;
    using ContractRequestDomain.Common;

    /// <summary>
    /// CABR-001
    /// </summary>
    public class AllocationPeriodTypeValidForFundingStreamCodeRule : IRule<contractRequestType>
    {
        private readonly IList<FundingConfigurationDataType> _validFundingConfig;

        public AllocationPeriodTypeValidForFundingStreamCodeRule(IEnumerable<FundingConfigurationDataType> validFundingConfig)
        {
            _validFundingConfig = validFundingConfig.ToList();
        }

        public string ErrorMessage => ErrorMessages.PeriodTypeNotValidForFundingStreamCodeRule;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetAllocations()
                .Where(
                    a => !_validFundingConfig.Any(fc => fc.FundingStreamCode == a.fundingStreamCode))
                .Select(a => a.correlationId);
        }
    }
}