namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// This rule is for MBR-001 
    /// </summary>
    public class MasterContractAmendmentRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.MasterContractAmendmentCrmIntentError;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.MasterContract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> errorList = new List<string>();
            if (itemToValidate.contract.CRMIntent == intent.Amendment && string.IsNullOrEmpty(itemToValidate.contract.contractNumber))
            {
                errorList.Add(itemToValidate.contract.correlationId);
            }

            return errorList;
        }
    }
}
