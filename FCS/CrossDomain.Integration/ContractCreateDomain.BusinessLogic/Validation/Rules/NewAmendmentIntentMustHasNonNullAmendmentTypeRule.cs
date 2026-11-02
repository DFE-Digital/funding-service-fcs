namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-012 - If CRM intent is 'Amendment', Amendment Type must not be null
    /// </summary>
    public class AmendmentIntentMustHasNonNullAmendmentTypeRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.AContractAmendmentMustHaveAnAmendmentType;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetAllContracts()
                .Where(c => c.CRMIntent == intent.Amendment && c.amendmentType == amendmentType.None)
                .Select(a => a.correlationId);
        }
    }
}