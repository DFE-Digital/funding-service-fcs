namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities;

    /// <summary>
    ///     CABR-005
    /// </summary>
    public class AllocationValidLepCodeRule : IRule<contractRequestType>
    {
        private readonly List<string> _validLepCodes;

        public AllocationValidLepCodeRule(IEnumerable<string> validLepCodes)
        {
            _validLepCodes = validLepCodes.ToList();
        }

        public string ErrorMessage => ErrorMessages.LepMustBeValid;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.GetAllocations().Where(IsInvalidLepCode).Select(a => a.correlationId);
        }

        private bool IsInvalidLepCode(contractAllocation a)
        {
            bool isEsfAllocation = ESFFundingStreams.FundingStreams.Contains(a.fundingStreamCode);
            return (isEsfAllocation && (a.LEPCode == null || !_validLepCodes.Contains(a.LEPCode))) // no need to explicitly check for empty or whitespace coz they are not valid and will be caught anyway
                   || (!isEsfAllocation && a.LEPCode != null);
        }
    }
}