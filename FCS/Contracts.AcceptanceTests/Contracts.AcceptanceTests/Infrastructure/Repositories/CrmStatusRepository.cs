namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;
    using Services;

    public static class CrmStatusRepository
    {
        public static EntityReference GetStatus(string statusName)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_statusSet.FirstOrDefault(s => s.sfa_name == statusName)?.ToEntityReference();
            }
        }

        public static string GetStatusText(Guid id)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_statusSet.Single(s => s.sfa_statusId == id).sfa_name;
            }
        }
    }
}
