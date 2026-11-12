namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-013b. If CRM intent is 'RevisedNew', a Contract number must exist and all previous versions must be withdrawn
    /// </summary>
    public class RevisedNewContractNumberMustExistRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.ContractNumberMustExistInTheSystem;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetSubContracts()
                .Where(c => c.CRMIntent == Intent.RevisedNew && !c.IsWithdrawnContractWithContractNumberPresentInCrm)
                .Select(a => a.correlationId);
        }
    }
}
