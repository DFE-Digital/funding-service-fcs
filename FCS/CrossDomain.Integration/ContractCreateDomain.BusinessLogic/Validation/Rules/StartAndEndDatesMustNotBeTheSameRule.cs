namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-010. Start and end date same for contract
    /// </summary>
    public class StartAndEndDatesMustNotBeTheSameContractRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.StartAndEndDateCannotBeTheSameForTheContract;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public System.Collections.Generic.IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
                .GetAllContracts()
                .Where(c => c.startDate == c.endDate || c.startDate.Equals(c.endDate))
                .Select(a => a.correlationId);
        }
    }
}