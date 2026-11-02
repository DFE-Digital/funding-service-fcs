namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class ContractMustBeInCorrectStateRule : IRule<contractRequestType>
    {
        public string RuleNumber
        {
            get { return "UDC-002"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.ContractMustBeInCorrectState; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Contract; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            var masterContract = contractRequest.contract;
            var failures = new List<string>();
            var contract = masterContract.contracts.First();

            if (contract.status == ContractStatus.Draft
                &&
                (contract.subStatus == ContractStatus.InReview || contract.subStatus == ContractStatus.Unassigned || contract.subStatus == ContractStatus.AwaitingDocumentation))
            {
                return failures; // No failures
            }

            failures.Add(contract.correlationId);

            return failures;
        }
    }
}