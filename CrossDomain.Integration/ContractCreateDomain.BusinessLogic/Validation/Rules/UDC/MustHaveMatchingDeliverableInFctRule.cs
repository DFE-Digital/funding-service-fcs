namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class MustHaveMatchingDeliverableInFctRule : IRule<contractRequestType>
    {
        public string RuleNumber
        {
            get { return "UDC-012"; }
        }

        public string ErrorMessage
        {
            get { return ValidationRuleErrorMessages.MustHaveMatchingDeliverableInFct; }
        }

        public errorInfoTypeLevel ErrorLevel
        {
            get { return errorInfoTypeLevel.Deliverable; }
        }

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            var masterContract = contractRequest.contract;
            var failures = new List<string>();
            var contract = masterContract.contracts.First();

            contract.contractAllocations.ForEach(ca =>
            {
                ca.contractDeliverables.ForEach(d =>
                {
                    if (d.crmNotPresent)
                    {
                        failures.Add(d.correlationId);
                    }
                });
            });

            return failures;
        }
    }
}