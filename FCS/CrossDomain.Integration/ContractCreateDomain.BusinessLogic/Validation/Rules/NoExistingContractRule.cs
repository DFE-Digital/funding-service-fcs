namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;
    using System.Linq;

    /// <summary>
    /// CBR-012b - Cannot create Contract as there is not already an existing Contract for the same period - required for ammendments and RevisedNew intents
    /// </summary>
    public class NoExistingContractRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.ExistingContractDoesntExistForGivenNaturalKey;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.contract.contracts.Where(c => !c.IsContractNumberWithMatchingUKPRNPeriodAndFundingTypePresentInCrm).Select(c => c.correlationId);
        }
    }
}
