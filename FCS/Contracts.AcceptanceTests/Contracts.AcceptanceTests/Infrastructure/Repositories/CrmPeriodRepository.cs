namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;

    public static class CrmPeriodRepository
    {
        public static string GetPeriodText(Guid id)
        {
            using (var xrmContext = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return xrmContext.sfa_periodSet.Single(p => p.sfa_periodId == id).sfa_periodname;
            }
        }
    }
}
