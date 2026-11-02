namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// UDC-022. An Update Draft Contract cannot be run against an existing contract with an amendment type.
    /// </summary>
    public class UpdateDraftContractCannotRunAgainstContractWithAmendmentTypeRule : IRule<contractRequestType>
    {
        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.UpdateDraftContractCannotRunAgainstContractWithAmendmentType; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Contract; }
        }
        
        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
            var failures = new List<string>();
            var masterContract = itemToValidate.contract;

            foreach (var contract in masterContract.contracts)
            {
                if (contract.amendmentType != amendmentType.None)
                {
                    failures.Add(contract.correlationId);
                }
            }

            return failures;
        }
    }
}