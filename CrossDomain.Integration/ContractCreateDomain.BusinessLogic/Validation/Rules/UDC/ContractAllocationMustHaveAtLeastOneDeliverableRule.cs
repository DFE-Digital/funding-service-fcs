namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class ContractAllocationMustHaveAtLeastOneDeliverableRule : IRule<contractRequestType>
    {
        public string RuleNumber
        {
            get { return "UDC-016"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.ContractAllocationMustHaveAtLeastOneDeliverable; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Allocation; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            var masterContract = contractRequest.contract;
            var failures = new List<string>();

            masterContract.contracts.First().contractAllocations.ForEach(ca =>
            {
                if (!ca.contractDeliverables.Any())
                {
                    failures.Add(ca.correlationId);
                }
            });

            return failures;
        }
    }
}