namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class ContractTypeMandatoryRule : IRule<contractRequestType>
    {
        public string ErrorMessage => "Contract Type must be set";
        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;
        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.contract.contracts.Where(c => string.IsNullOrEmpty(c.contractType1))
                .Select(c => c.correlationId)
                .ToList();
        }
    }
}
