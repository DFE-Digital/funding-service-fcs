namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using SFA.FCT.ContractRequestDomain.Common;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities;

    /// <summary>
    /// This rule is for CABR-020
    /// </summary>
    public class AllocationValidRegionTypeRule : IRule<contractRequestType>
    {
        private readonly List<string> _validRegionTypes;

        public AllocationValidRegionTypeRule(IEnumerable<string> regionTypes)
        {
            if (regionTypes == null)
                regionTypes = new List<string>();

            _validRegionTypes = regionTypes.ToList();
        }

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public string ErrorMessage => ErrorMessages.RegionTypeMustBeValid;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.GetAllocations().Where(IsInvalidRegionType).Select(a => a.correlationId);
        }

        private bool IsInvalidRegionType(contractAllocation a)
        {
            bool isEsfAllocation = ESFFundingStreams.FundingStreams.Contains(a.fundingStreamCode);

            return (isEsfAllocation && (string.IsNullOrWhiteSpace(a.regionType) || !_validRegionTypes.Contains(a.regionType)))
                    || (!isEsfAllocation && !string.IsNullOrWhiteSpace(a.regionType));
        }
    }
}
