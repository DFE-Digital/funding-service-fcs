namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Services;

    public static class CrmTransitionRepository
    {
        public static Guid GetTransitionId(string transitionName)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_transitionSet.Single(t => t.sfa_name == transitionName).Id;
            }
        }
    }
}
