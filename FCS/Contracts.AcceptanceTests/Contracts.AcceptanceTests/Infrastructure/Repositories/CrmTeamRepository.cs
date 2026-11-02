namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using Microsoft.Xrm.Sdk;
    using Services;

    public static class CrmTeamRepository
    {
        public static EntityReference GetTeamEntityReference(string teamName)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.TeamSet.Single(t => t.Name == teamName).ToEntityReference();
            }
        }
    }
}
