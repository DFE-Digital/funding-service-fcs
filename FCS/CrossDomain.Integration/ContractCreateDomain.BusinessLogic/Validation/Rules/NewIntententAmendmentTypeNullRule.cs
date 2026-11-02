namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;
    using ContractRequestDomain.Common;

    /// <summary>
    /// CBR-011 - If CRM intent is 'New', Amendment Type must be null
    /// </summary>
    public class NewIntententAmendmentTypeNullRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.ANewContractMustHaveAmendmentNotSet;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetAllContracts()
                .Where(c => (c.CRMIntent == intent.New || c.CRMIntent == intent.NewAmendment) && c.amendmentType != amendmentType.None)
                .Select(a => a.correlationId);
        }
    }
}