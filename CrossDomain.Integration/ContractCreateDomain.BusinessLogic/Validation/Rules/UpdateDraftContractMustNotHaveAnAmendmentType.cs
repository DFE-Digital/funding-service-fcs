namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-011a - If CRM intent is 'Update Draft ', Amendment Type must be null
    /// </summary>
    public class UpdateDraftContractMustNotHaveAnAmendmentTypeRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.UpdateDraftContractMustNotHaveAnAmendmentType;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetAllContracts()
                .Where(c => c.CRMIntent == Intent.UpdateDraft && c.amendmentType != amendmentType.None)
                .Select(a => a.correlationId);
        }
    }
}