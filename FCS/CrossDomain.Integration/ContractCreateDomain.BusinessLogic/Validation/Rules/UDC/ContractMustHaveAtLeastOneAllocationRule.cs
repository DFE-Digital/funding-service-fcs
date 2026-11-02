namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class ContractMustHaveAtLeastOneAllocationRule : IRule<contractRequestType>
    {
        public string RuleNumber
        {
            get { return "UDC-015"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.ContractMustHaveAtLeastOneAllocation; }
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

            if (!contract.contractAllocations.Any())
            {
                failures.Add(contract.correlationId);
            }

            return failures;
        }
    }
}