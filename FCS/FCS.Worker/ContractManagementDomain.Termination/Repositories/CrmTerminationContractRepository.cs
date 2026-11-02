namespace ContractManagementDomain.Termination.Repositories
{
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using DTOs;

    public class CrmTerminationContractRepository : ICrmTerminationContractRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmTerminationContractRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public SimpleContractTerminationInfo GetSimpleContractTerminationInfo(string contractNumber, int version,
            int subVersion)
        {
            using (XrmServiceContext xrmContext = new XrmServiceContext(_organizationService))
            {
                return xrmContext.sfa_contractSet.Where(c => c.sfa_number == contractNumber &&
                                                          c.sfa_Version == version &&
                                                          c.sfa_SubVersion == subVersion)
                    .Select(c => new {c.sfa_LatestVersion, c.sfa_terminationdate})
                    .AsEnumerable()
                    .Select(c => new SimpleContractTerminationInfo(c.sfa_LatestVersion.Value, c.sfa_terminationdate))
                    .Single();
            }
        }
    }
}
