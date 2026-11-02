namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;
    using ContractRequestDomain.Common;
    using Implementation.Persistence.Entities;

    /// <summary>
    /// CABR-006
    /// </summary>
    public class AllocationValidUoPCodeRule : IRule<contractRequestType>
    {
        private readonly List<UnitOfProcurement> _validUnitsOfProcurement;

        public AllocationValidUoPCodeRule(IEnumerable<UnitOfProcurement> validUnitsOfProcurement)
        {
            _validUnitsOfProcurement = validUnitsOfProcurement.ToList();
        }

        public string ErrorMessage => ErrorMessages.UoPMustBeValid;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType contract)
        {
            return contract
                .GetAllocations()
                .Where(a => !IsUopCodeValid(a))
                .Select(a => a.correlationId);
        }

        private bool IsUopCodeValid(contractAllocation allocation)
        {
            bool allocationShouldHaveUop =
                _validUnitsOfProcurement.Select(uop => uop.FundingStreamPeriodCode)
                    .Contains(allocation.fundingStreamPeriodCode);

            return allocationShouldHaveUop
                 ? IsFundingStreamPeriodAndUopValid(allocation.fundingStreamPeriodCode, allocation.UoPCode)
                 : string.IsNullOrEmpty(allocation.UoPCode);
        }

        private bool IsFundingStreamPeriodAndUopValid(string fsp, string uop)
        {
            return _validUnitsOfProcurement.Any(validUop =>
                    validUop.Code == uop && validUop.FundingStreamPeriodCode == fsp);
        }
    }
}