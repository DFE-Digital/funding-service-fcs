namespace PaymentManagementDomain.PaymentSchedule.PaymentAggregated.Repositories
{
    extern alias IntegrationEntities;
    using System.Collections.Concurrent;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using IntegrationEntities::SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public class FundingStreamPeriodRepository : IFundingStreamPeriodRepository
    {
        private static readonly ConcurrentDictionary<string, EntityReference> FundingStreamPeriodEntityReferences =
            new ConcurrentDictionary<string, EntityReference>();

        private readonly IOrganizationService _organizationService;

        public FundingStreamPeriodRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public EntityReference GetFundingStreamPeriod(string fundingStreamPeriodCode)
        {
            return FundingStreamPeriodEntityReferences.GetOrAdd(fundingStreamPeriodCode, GetFundingStreamPeriodFromCrm);
        }

        private EntityReference GetFundingStreamPeriodFromCrm(string fspCode)
        {
            using (var xrmContext = new XrmServiceContext(_organizationService))
            {
                return xrmContext.sfa_fundingstreamperiodSet.Single(fsp => fsp.sfa_fundingstreamperiodcode == fspCode)
                    .ToEntityReference();
            }
        }
    }
}
