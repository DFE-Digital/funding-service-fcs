namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractManagement.DataStore.Model;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// Rule CABR-015
    /// </summary>
    public class InvalidFundingStreamPeriodCodeRule : IRule<contractRequestType>
    {
        private readonly IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> _ftpFspData;

        public InvalidFundingStreamPeriodCodeRule(IReadOnlyCollection<FundingTypePeriodFundingStreamPeriod> ftFspData)
        {
            _ftpFspData = ftFspData;
        }

        public string ErrorMessage => ErrorMessages.InvalidFundingStreamCode;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            periodType contractPeriod = itemToValidate.contract.contracts.First().period;
            string periodTypeCode = contractPeriod.periodType1.periodTypeCode;
            string period = contractPeriod.period;
            string fundingPeriodCode = $"{periodTypeCode}{period}";
            return itemToValidate.GetAllocations()
                .Where(a => IsInvalidFundingStreamCode(itemToValidate.contract.fundingTypeCode, fundingPeriodCode, a.fundingStreamCode))
                .Select(a => a.correlationId);
        }

        private bool IsInvalidFundingStreamCode(string fundingTypeCode, string fundingPeriodCode, string fundingStreamCode)
        {
            return !_ftpFspData.Any(
                    data => data.FundingStreamCode == fundingStreamCode &&
                    data.FundingPeriodCode == fundingPeriodCode &&
                    data.FundingTypeCode == fundingTypeCode);
        }
    }
}
