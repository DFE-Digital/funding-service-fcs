namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class OrganisationRepository : IOrganisationRepository
    {
        private readonly IOrganizationService _organizationService;

        public OrganisationRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public Guid GetOrganisationEntityId(string ukprn)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                return xrmContext.AccountSet.Single(org => org.sfa_UKPRN == ukprn).Id;
            }
        }
    }
}
