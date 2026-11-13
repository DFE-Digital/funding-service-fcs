namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    extern alias IntegrationEntities;
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Xrm;

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
