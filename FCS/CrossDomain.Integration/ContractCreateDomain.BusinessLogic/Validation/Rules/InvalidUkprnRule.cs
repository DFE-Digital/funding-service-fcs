namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// This rule is for CBR-001
    /// </summary>
    public class InvalidUkprnRule : ISevereRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.UkprnIsNotValid;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.MasterContract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            List<string> localErrors = new List<string>();

            if (string.IsNullOrEmpty(itemToValidate.contract.contractor.legalName))
            {
                localErrors.Add(itemToValidate.contract.correlationId);
            }

            return localErrors;
        }
    }
}
