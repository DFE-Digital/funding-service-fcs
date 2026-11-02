namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class DeliverableMustHaveActiveUkprnRule : IRule<contractRequestType>
    {
        private static readonly IList<string> OrgInactiveStatusList = new List<string>
        {
            "IN LIQUIDATION", "INACTIVE", "DISSOLVED", "DELETED"
        };

        public string RuleNumber => "UDC-014";

        public string ErrorMessage  => ValidationRuleErrorMessages.DeliverableMustHaveActiveUkprn;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Deliverable;

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            var masterContract = contractRequest.contract;
            var failures = new List<string>();

            if (!IsOrgStatusInactive(masterContract.contractor))
            {
                return failures; // No failures
            }

            masterContract.contracts.First().contractAllocations.ForEach(ca =>
            {
                ca.contractDeliverables.ForEach(d =>
                {
                    failures.Add(d.correlationId);
                });
            });

            return failures;
        }
        private bool IsOrgStatusInactive(contractor contractor)
        {
            bool response = true;

            if (contractor != null && !string.IsNullOrWhiteSpace(contractor.organisationStatus))
            {
                response = OrgInactiveStatusList.Contains(contractor.organisationStatus.ToUpper());
            }

            return response;
        }
    }
}