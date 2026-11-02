namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class MustHaveMatchingContractInFctRule : IRule<contractRequestType>
    {
        public string RuleNumber
        {
            get { return "UDC-009"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.MustHaveMatchingContractInFct; }
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

            if (contract.crmNotPresent)
            {
                failures.Add(contract.correlationId);
            }

            return failures;
        }
    }
}