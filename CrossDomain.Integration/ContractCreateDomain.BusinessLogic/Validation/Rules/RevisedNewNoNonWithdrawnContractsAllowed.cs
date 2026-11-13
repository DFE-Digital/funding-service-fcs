namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-013d. If CRM intent is 'Revised New', all previous versions of the Contract associated with the Contract Number must never have been Approved,
    /// i.e. withdrawn or superseded draft.
    /// </summary>

    public class RevisedNewNoNonWithdrawnContractsAllowed : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.NoPreviousNonWithdrawnContractsAllowedForRevisedNewIntent;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetSubContracts()
                .Where(c => c.CRMIntent == Intent.RevisedNew && c.IsNonWithdrawnOrSupersededDraftContractWithContractNumberPresentInCrm)
                .Select(a => a.correlationId);
        }
    }
}
