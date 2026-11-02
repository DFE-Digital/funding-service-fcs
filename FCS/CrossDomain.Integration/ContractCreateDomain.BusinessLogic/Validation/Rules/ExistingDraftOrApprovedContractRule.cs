namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;

    using CrossDomain.Integration.Entities.ContractRequest;

    using SFA.FCT.ContractRequestDomain.Common;

    public class ExistingDraftOrApprovedContractRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.ADraftOrApprovedContractAlreadyExistsForTheUkprn;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            return itemToValidate.contract.contracts
                    .Where(c => c.IsDraftOrApprovedContractForUkprnPresentInCrm)
                    .Select(c => c.correlationId);
        }
    }
}