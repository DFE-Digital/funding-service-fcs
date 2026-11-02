namespace SFA.FCT.ContractCreateDomain.Implementation.Repositories
{
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;

    public class NumberPrefixRepository : INumberPrefixRepository
    {
        private readonly IOrganizationService _organizationService;

        public NumberPrefixRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public string GetMasterContractPrefix(string fundingType)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                return (
                    from ft in context.sfa_fundingtypeSet
                    join a in context.sfa_agencySet on ft.sfa_AgencyId.Id equals a.sfa_agencyId
                    where ft.sfa_fundingtypecode == fundingType
                    select a.sfa_contractreferenceprefix
                    ).Single();
            }
        }

        public string GetContractPrefix(string fundingType)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                return (
                    from ft in context.sfa_fundingtypeSet
                    where ft.sfa_fundingtypecode == fundingType
                    select ft.sfa_ContractReferencePrefix
                    ).Single();
            }
        }

        public string GetAllocationPrefix(string fundingStreamPeriod)
        {
            using (XrmServiceContext context = new XrmServiceContext(_organizationService))
            {
                return (
                    from fsp in context.sfa_fundingstreamperiodSet
                    where fsp.sfa_fundingstreamperiodcode == fundingStreamPeriod
                    select fsp.sfa_AllocationReferencePrefix
                    ).Single();
            }
        }
    }
}