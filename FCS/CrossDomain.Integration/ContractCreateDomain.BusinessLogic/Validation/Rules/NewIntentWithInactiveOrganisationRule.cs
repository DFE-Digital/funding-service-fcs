namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CBR-002 Cannot create a new Contract If CRM Intent = 'New' and UKPRN is not active
    /// </summary>
    public class NewIntentWithInactiveOrganisationRule : IRule<contractRequestType>
    {
        private static readonly IList<string> OrgInactiveStatusList = new List<string>
        {
            "IN LIQUIDATION", "INACTIVE", "DISSOLVED", "DELETED"
        };

        public string ErrorMessage => ErrorMessages.UkprnIsNotActiveSoCannotCreate;

        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Contract;

        public IEnumerable<string> GetFailuresForItem(contractRequestType itemToValidate)
        {
             return itemToValidate
                .GetSubContracts()
                .Where(c => c.CRMIntent == intent.New && IsOrgStatusInactive(c.contractor))
                .Select(c => c.correlationId);
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
