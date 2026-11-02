namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// UDC-019. Cannot create a draft Contract Amendment if there is already an existing draft contract.
    /// </summary>
    public class ContractAmendmentCannotHaveExistingDraftContractRule : IRule<contractRequestType>
    {
        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.ContractAmendmentCannotHaveExistingDraft; }
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
                if (contract.IsDraftContractWithContractNumberPresentInCrm)
                {
                    failures.Add(contract.correlationId);
                }
            }

            return failures;
        }
    }
}