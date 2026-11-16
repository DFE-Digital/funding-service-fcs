namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules.UDC
{
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class ContractAllocationMustHaveActiveUkprnRule : IRule<contractRequestType>
    {
        private static readonly IList<string> OrgInactiveStatusList = new List<string>
        {
            "IN LIQUIDATION", "INACTIVE", "DISSOLVED", "DELETED"
        };

        public string RuleNumber => "UDC-013"; 
        

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;
        
        
        public string ErrorMessage => ValidationRuleErrorMessages.ContractAllocationMustHaveActiveUkprn; 
       

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
                failures.Add(ca.correlationId);
            });

            return failures;
        }

        private bool IsOrgStatusInactive(Contractor contractor)
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