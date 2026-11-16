namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-013a. If CRM intent is 'RevisedNew', a Contract number must be specified
    /// </summary>
    public class RevisedNewContractsMustHaveContractNumberRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.ContractNumberAndMasterMustBeSpecified;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            // first add the master
            List<contractType> allContractTypes = new List<contractType> {itemToValidate.contract};

            // now the sub contracts
            allContractTypes.AddRange(itemToValidate
                .GetSubContracts());

            return allContractTypes.Where(c => c.CRMIntent == Intent.RevisedNew && string.IsNullOrEmpty(c.contractNumber))
                .Select(a => a.correlationId);
        }
    }
}
