namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-013. If CRM intent is 'New' or 'NewAmendment', a Contract number cannot be specified
    /// </summary>
    public class NewContractsMustNotHaveContractNumbersRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.AContractNumberCannotBeSetForANewContract;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetSubContracts()
                .Where(c => c.CRMIntent.IsNewOrNewAmendment() && c.HasContractNumber())
                .Select(a => a.correlationId);
        }
    }
}
