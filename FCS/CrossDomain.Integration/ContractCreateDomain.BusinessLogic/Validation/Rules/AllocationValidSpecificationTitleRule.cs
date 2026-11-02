namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using SFA.FCT.CrossDomain.Integration.Entities;

    /// <summary>
    ///     CABR-018
    ///     Specification Title must be a valid specification (and not exist if the contract is not an ESF)
    /// </summary>
    public class AllocationValidSpecificationTitleRule : IRule<contractRequestType>
    {
        private readonly List<string> _validSpecificationTitles;
        public AllocationValidSpecificationTitleRule(IEnumerable<string> validSpecificationTitles)
        {
            _validSpecificationTitles = validSpecificationTitles.ToList();
        }

        public string ErrorMessage => ErrorMessages.AllocationSpecificationTitleInvalid;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.GetAllocations().Where(IsInvalidSpecificationTitle).Select(a => a.correlationId);
        }

        private bool IsInvalidSpecificationTitle(contractAllocation a)
        {
            bool isEsfAllocation = ESFFundingStreams.FundingStreams.Contains(a.fundingStreamCode);

            return (isEsfAllocation && (string.IsNullOrWhiteSpace(a.specificationTitle) || !_validSpecificationTitles.Contains(a.specificationTitle)))
                    || (!isEsfAllocation && !string.IsNullOrWhiteSpace(a.specificationTitle));
        }
    }
}