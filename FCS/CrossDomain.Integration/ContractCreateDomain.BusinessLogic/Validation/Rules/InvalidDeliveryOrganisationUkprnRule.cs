namespace SFA.FCT.ContractCreateDomain.BusinessLogic.Validation.Rules
{
    using System.Collections.Generic;
    using System.Linq;
    using ContractRequestDomain.Common;
    using CrossDomain.Integration.Entities.ContractRequest;

    /// <summary>
    /// CABR-027
    /// </summary>
    public class InvalidDeliveryOrganisationUkprnRule : IRule<contractRequestType>
    {
        public string ErrorMessage => ErrorMessages.InvalidDeliveryOrganisationUkprn;
        public errorInfoTypeLevel ErrorLevel => errorInfoTypeLevel.Allocation;

        public IEnumerable<string> GetFailuresForItem(contractRequestType contractRequest)
        {
            return
                contractRequest
                    .GetAllocations()
                    .Where(ca => ca.HasDeliveryOrganisation() && string.IsNullOrEmpty(ca.DeliveryOrganisationDetail.legalName))
                    .Select(ca => ca.correlationId);
        }
    }
}
