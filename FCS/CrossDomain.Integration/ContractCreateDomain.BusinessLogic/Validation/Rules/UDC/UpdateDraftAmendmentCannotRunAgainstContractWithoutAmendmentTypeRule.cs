namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// UDC-021. An Update Draft Amendment cannot be run against a contract without an amendment type.
    /// </summary>
    public class UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentTypeRule : IRule<contractRequestType>
    {
        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.UpdateDraftAmendmentCannotRunAgainstContractWithoutAmendmentType; }
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
                if (!contract.IsApprovedContractWithContractNumberPresentInCrm || !contract.IsDraftContractWithContractNumberPresentInCrm)
                {
                    failures.Add(contract.correlationId);
                }
            }

            return failures;
        }
    }
}