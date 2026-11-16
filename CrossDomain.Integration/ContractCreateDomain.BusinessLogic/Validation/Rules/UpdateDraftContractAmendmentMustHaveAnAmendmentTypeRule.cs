namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-012a - If CRM intent is 'Update Draft Amendment', Amendment Type must not be null
    /// </summary>
    public class UpdateDraftAmendmentMustHaveAnAmendmentTypeRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.AnUpdateDraftAmendmentMustHaveAnAmendmentType;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetAllContracts()
                .Where(c => c.CRMIntent == Intent.UpdateDraftAmendment && c.amendmentType == amendmentType.None)
                .Select(a => a.correlationId);
        }
    }
}