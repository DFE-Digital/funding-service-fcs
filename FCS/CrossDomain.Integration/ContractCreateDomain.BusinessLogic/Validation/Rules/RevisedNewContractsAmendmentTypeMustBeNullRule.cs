

namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;

    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-013c. If CRM intent is 'Revised New', Amendment Type must be null
    /// </summary>
    public class RevisedNewContractsAmendmentTypeMustBeNullRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.ARevisedNewContractMustHaveAmendmentNotSet;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetAllContracts()
                .Where(c => c.CRMIntent == intent.RevisedNew && c.amendmentType != amendmentType.None)
                .Select(a => a.correlationId);
        }
    }
}