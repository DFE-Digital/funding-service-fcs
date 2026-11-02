namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// This rule is for MBR-002
    /// </summary>
    public class MasterContractNewIntentRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.MasterContractNewCrmIntentError;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.MasterContract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> errorList = new List<string>();
            if (itemToValidate.contract.CRMIntent == intent.New && !string.IsNullOrEmpty(itemToValidate.contract.contractNumber))
            {
                errorList.Add(itemToValidate.contract.correlationId);
            }

            return errorList;
        }
    }
}
