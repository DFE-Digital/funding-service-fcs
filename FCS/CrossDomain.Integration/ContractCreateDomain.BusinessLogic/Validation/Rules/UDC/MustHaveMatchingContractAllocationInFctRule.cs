namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class MustHaveMatchingContractAllocationInFctRule : IRule<contractRequestType>
    {       
        public string RuleNumber
        {
            get { return "UDC-010"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.MustHaveMatchingContractAllocationInFct; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Allocation; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            var masterContract = contractRequest.contract;
            var failures = new List<string>();
            var contract = masterContract.contracts.First();

            contract.contractAllocations.ForEach(ca =>
            {
                if (ca.crmNotPresent)
                {
                    failures.Add(ca.correlationId);
                }
            });

            return failures;
        }
    }
}