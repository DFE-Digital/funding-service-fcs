namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Linq;
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-007 - Cannot create Contract as there is already an existing Contract for the same period
    /// </summary>
    public class ExistingContractRule : IRule<contractRequestType>
    {
        private readonly bool _multipleOverlappingContractsAllowedForFundingType;

        public ExistingContractRule(bool multipleOverlappingContractsAllowedForFundingType)
        {
            _multipleOverlappingContractsAllowedForFundingType = multipleOverlappingContractsAllowedForFundingType;
        }

        public string ErrorMessage => ErrorMessages.AContractAlreadyExistsForTheUKPRNandPeriod;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.contract.contracts
                .Where(c => c.IsContractWithMatchingUKPRNPeriodAndFundingTypePresentInCrm && !_multipleOverlappingContractsAllowedForFundingType)
                .Select(c => c.correlationId);
        }
    }
}