namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public class ContractStartAndEndDateMandatoryRule : IRule<contractRequestType>
    {
        public string ErrorMessage => "The Contract must have a start and end date";
        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;
        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
           return itemToValidate.contract.contracts.Where(c => c.startDate == null || c.endDate == null)
                .Select(c => c.correlationId)
                .ToList();
        }
    }
}
