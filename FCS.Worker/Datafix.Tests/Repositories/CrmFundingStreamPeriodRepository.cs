namespace Datafix.Tests.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public static class CrmFundingStreamPeriodRepository
    {
        public static Guid GetFspId(string fspCode)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_fundingstreamperiodSet.Where(fsp => fsp.sfa_fundingstreamperiodcode == fspCode)
                    .Select(fsp => fsp.Id).Single();
            }
        }
    }
}
