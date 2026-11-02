namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;
    using ContractRequestDomain.Common;
    
    /// <summary>
    /// CABR-014 - If CRM intent is 'New', Contract Allocation Number must be null
    /// </summary>
    public class NewIntentContractAllocationNumberNullRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.NewAllocationMustNotHaveAllocationNumber;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate
               .GetAllocations()
               .Where(c => (c.CRMIntent == intent.New || c.CRMIntent == intent.RevisedNew) && c.contractAllocationNumber != null)
               .Select(a => a.correlationId);
        }
    }
}
