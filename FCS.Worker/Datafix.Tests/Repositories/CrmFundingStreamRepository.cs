namespace Datafix.Tests.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public static class CrmFundingStreamRepository
    {
        public static Guid GetFsId(string fsCode)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_fundingstreamSet.Where(fs => fs.sfa_fundingstreamcode == fsCode)
                    .Select(fsp => fsp.Id).Single();
            }
        }
    }
}
