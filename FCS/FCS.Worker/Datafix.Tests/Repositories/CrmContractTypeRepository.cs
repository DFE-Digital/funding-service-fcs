namespace Datafix.Tests.Repositories
{
    using System;
    using System.Linq;
    using Microsoft.Xrm.Sdk;
    using SFA.FCS.Worker.Common.Crm;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public static class CrmContractTypeRepository
    {
        public static Guid GetContractTypeId(string contractType)
        {
            IOrganizationService organizationService = CrmConnectionFactory.GetRetryOnErrorOrganizationService();

            using (XrmServiceContext context = new XrmServiceContext(organizationService))
            {
                return context.sfa_contracttypeSet.Where(ct => ct.sfa_name == contractType)
                    .Select(ct => ct.sfa_contracttypeId.Value).Single();
            }
        }
    }
}
